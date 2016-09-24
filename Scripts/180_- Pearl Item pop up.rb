#===============================================================================
# * Falcao Pearl ABS script shelf # 8
#
# Item and gold pop up v 1.0
# This is just an add on for the Pearl ABS system, it run as standalone mode too
#
# Website: http://falcaorgss.wordpress.com/
# Foro: www.makerpalace.com
#===============================================================================
#
# * Installation
# This work as plug and play, copy and paste the script above main
#
# * Usage
# There is no special references, when you earn an item or gold, then pop appear
# Edit the module below for convenience
#-------------------------------------------------------------------------------
module PearlItemPop
  
  # Position X of the pop up object
  Pos_X = 10
  
  # Position Y of the pop up object
  Pos_Y = 320
  
  # Icon displayed when earnig gold
  GoldIcon = 558
  
  # Se sound played when gaining items (set nil if you dont want to play sound)
  ItemSe = "Item3"
  
  # Se sound played when gainig gold (set nil if you dont want to play sound)
  GoldSe = "Shop"
  
end
class Game_Party < Game_Unit
  #-----------------------------------------------------------------------------
  # *) alias: gain_item
  #-----------------------------------------------------------------------------
  alias falcaopearl_itempop_gain gain_item
  def gain_item(item, amount, include_equip = false)
    
    if !item_container(item.class).nil? && SceneManager.scene_is?(Scene_Map)
      if amount > 0
        #$game_system.item_object = [item, amount]
        info = sprintf("Party has gained item: %s (x%s)",item.name, amount)
        SceneManager.display_info(info)
        RPG::SE.new(PearlItemPop::ItemSe, 80).play rescue nil
      end
    end
    falcaopearl_itempop_gain(item, amount, include_equip = false)
  end
  #-----------------------------------------------------------------------------
  # *) alias: gain_gold
  #-----------------------------------------------------------------------------
  alias falcaopearl_itempop_gold gain_gold
  def gain_gold(amount)
    if SceneManager.scene_is?(Scene_Map)
      #$game_system.item_object = [nil, amount]
      info = sprintf("Party has gained gold: %s", amount)
      SceneManager.display_info(info)
      RPG::SE.new(PearlItemPop::GoldSe, 80).play rescue nil
    end
    falcaopearl_itempop_gold(amount)
  end
end
#=============================================================================
# *) Game_System
#=============================================================================
class Game_System
  attr_accessor :item_object
end
#=============================================================================
# *) Spriteset_Map
#=============================================================================
class Spriteset_Map
  #-----------------------------------------------------------------------------
  # *) alias: gain_gold
  #-----------------------------------------------------------------------------
  alias falcaopearl_itempop_create create_pictures
  def create_pictures
    create_itempop_sprites
    falcaopearl_itempop_create
  end
  #-----------------------------------------------------------------------------
  # *) alias: create_itempop_sprites
  #-----------------------------------------------------------------------------
  def create_itempop_sprites
    @item_object = $game_system.item_object
    @item_sprite = Sprite_PopItem.new(@viewport2, @item_object) if
    not @item_object.nil?
  end
  #-----------------------------------------------------------------------------
  # *) alias: update
  #-----------------------------------------------------------------------------
  alias falcaopearl_itempop_update update
  def update
    if !@item_sprite.nil?
      unless @item_sprite.disposed?
        @item_sprite.update 
      else
        @item_sprite.dispose
        @item_object = nil
        $game_system.item_object = nil
        @item_sprite = nil
      end
    end
    if @item_object != $game_system.item_object
      @item_sprite.dispose if !@item_sprite.nil?
      @item_sprite = nil
      @item_sprite = Sprite_PopItem.new(@viewport2, $game_system.item_object)
      @item_object = $game_system.item_object
    end
    falcaopearl_itempop_update
  end
  #-----------------------------------------------------------------------------
  # *) alias: dispose
  #-----------------------------------------------------------------------------
  alias falcaopearl_itempop_dispose dispose
  def dispose
    @item_sprite.dispose unless @item_sprite.nil?
    falcaopearl_itempop_dispose
  end
end
#=============================================================================
# *) Sprite_PopItem
#=============================================================================
class Sprite_PopItem < Sprite
  #-----------------------------------------------------------------------------
  # *) initialize
  #-----------------------------------------------------------------------------
  def initialize(viewport, item)
    super(viewport)
    @item = item[0]
    @num = item[1]
    set_bitmap
    self.x = PearlItemPop::Pos_X
    self.y = PearlItemPop::Pos_Y
    @erasetimer = 120
    update
  end
  #-----------------------------------------------------------------------------
  # *) update
  #-----------------------------------------------------------------------------
  def update
    super
    if @erasetimer > 0
      @erasetimer -= 1 
      self.opacity -= 10 if @erasetimer <= 25
      dispose if @erasetimer == 0
    end
  end
  #-----------------------------------------------------------------------------
  # *) dispose
  #-----------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  #-----------------------------------------------------------------------------
  # *) set_bitmap
  #-----------------------------------------------------------------------------
  def set_bitmap
    @item.nil? ? operand = Vocab::currency_unit : operand = @item.name
    string = operand + ' X' + @num.to_s
    self.bitmap = Bitmap.new(26 + string.length * 9, 28)
    self.bitmap.fill_rect(0, 0, self.bitmap.width, 28, Color.new(0, 0, 0, 100))
    self.bitmap.font.size = 20
    bitmap = Cache.system("Iconset")
    icon = @item.nil? ? PearlItemPop::GoldIcon : @item.icon_index
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    self.bitmap.blt(4, 0, bitmap, rect)
    self.bitmap.draw_text(28, 0, 250, 32, string)
  end
  #----------------------------------------------------------------------------
end
