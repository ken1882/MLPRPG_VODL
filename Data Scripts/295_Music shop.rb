module COMP
  module Music_Shop
    Buyable_Regex = /<buyable>/i
    ALBUM_Regex = /<buy[ _]music: (\d+)>/i
    
    ALBUM = [
    ["NULL"],
    ["SINGLE_MUSIC"],
    ["01 For a United Equestria (Vocals By EileMonty) - Pony Empires Complete","02 From Saddle Arabia - Pony Empires Complete","03 In Memoriam (Of The Crystal Ponies) - Pony Empires Complete","04 Griffon Kingdom - Pony Empires Complete","05 Dragons Of The South - Pony Empires Complete","06 Changeling Anthem - Pony Empires Complete","07 Zebra Tribes - Pony Empires Complete","08 Ahuizotl - Pony Empires Complete","09 Ordo Ad Chao - Pony Empires Complete","10 Buffalo Nation - Pony Empires Complete","11 Tartarus - Pony Empires Complete","12 The Shadow King - Pony Empires Complete","13 Muffinland - Pony Empires Complete","14 Sun (Vocals By MEMJ0123) - Pony Empires Complete","15 Moon (Vocals by Periluna) - Pony Empires Complete","16 Fellowship of Magic - Pony Empires Complete",],
    
    ]
  end
end

module RPG
  class Item
    $music_sheet_included = [] if $music_sheet_included == nil
    
    def in_music_sheet?
          p sprintf("current music sheet ID:" + self.id.to_s)
          for i in $music_sheet_included
              p sprintf("Included music sheet ID:%d",i)
              return true if i == self.id
          end
          return false
    end
    
    def album_id
      return @album_id unless @album_id.nil?
      res = COMP::Music_Shop::ALBUM_Regex.match(self.note)
      @album_id = res ? res[1].to_i : 0
      @album_feature = []
      for song_name in COMP::Music_Shop::ALBUM[@album_id]
        @album_feature.push(song_name)
      end
      return @album_id
    end
    
    def album_feature
      return 0 if !@album_id
      
      return @album_feature
    end
    
  end
 
end


class Game_MusicShop < Game_Shop
end

class Window_MusicShopCommand < Window_ShopCommand
  def make_command_list
    add_command(Vocab::ShopBuy,    :buy)
    add_command(Vocab::ShopCancel, :cancel)
  end
end

class Window_MusicShopStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
    @data = []
    @page_index = 0
    refresh
  end
  
  def actor
    return @data[index]
  end
  
  def item=(item)
    @item = item
    refresh
  end
  
  def make_item_list
    #@data = $game_party.battle_members
  end
  
  def item_max
    $game_party.battle_members.size
  end
  
  def item_height
    (height - standard_padding * 2) / 4
  end
  
  def enable?(trash)
    return false
  end
  
  
  def draw_item(index)
    return unless @item
    rect = item_rect(index)
    actor = @data[index]
    change_color(normal_color, enable?(actor))
#    draw_text(rect.x + 36, rect.y + 4, 112, line_height, actor.name)
#    draw_character(actor.character_name, actor.character_index, rect.x + 16, rect.y + line_height + 16)
  end
  
  def select_last
    select(0)
  end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  def process_ok
    unless enable?(actor)
      Sound.play_buzzer
    else
      super
    end
  end
end


class Window_MusicShopBuy < Window_ShopBuy

  alias :comp_music_shop_enable? :enable?
  def enable?(item)
    return false if item.in_music_sheet?
    return false unless item && price(item) <= @money
    comp_music_shop_enable?(item)
  end

  alias :comp_music_shop_include? :include?
  def include?(shopGood)
    return false unless shopGood.item.album_id > 0
    comp_music_shop_include?(shopGood)
  end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
  end
end


class Scene_MusicShop < Scene_Shop
  
  
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_MusicShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
    @status_window.set_handler(:cancel, method(:learn_cancel))
  end
  
  def create_command_window
    @command_window = Window_MusicShopCommand.new(@gold_window.x, @purchase_only)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:buy,    method(:command_buy))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_buy_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @buy_window =Window_MusicShopBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end
  
  def check_music_book(filename)
    return if $game_system.music_book_list == nil      
    return if filename == nil or filename == ""   
    
    found = false
    path = "Audio/BGM/"
    filename = path + filename
    
    for i in 0...$game_system.music_book_list.size
      song_name = path.to_s + $game_system.music_book_list[i][0].to_s
      if song_name.to_s == filename.to_s
          $game_system.music_book_list[i][1] = true
          found = true
          break
      end  
    end
  end
  
  
  def on_buy_ok
    @item = @buy_window.item
    @buy_window.hide
    @number_window.set(@item,1, buying_price, currency_unit)
    @number_window.show.activate
    @gold_window.refresh
    @status_window.refresh
  end
  
  def on_number_ok
      Sound.play_shop
      case @command_window.current_symbol
      when :buy
        do_buy(@number_window.number)
        check_music_book(@item.name.to_s)
        @item.album_id
        $music_sheet_included.push(@item.id)
        feature_songs = @item.album_feature
        if feature_songs.size > 1
          for song_name in feature_songs
            check_music_book(song_name.to_s)
          end
        end
        $music_sheet_included.push(@item.id)
      when :sell
        do_sell(@number_window.number)
      end
      end_number_input
      @gold_window.refresh
      @status_window.refresh
  end
    
  def learn_cancel
    @status_window.unselect
    @buy_window.activate
  end
  
end