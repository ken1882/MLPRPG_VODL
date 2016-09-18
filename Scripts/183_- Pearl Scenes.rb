#===============================================================================
# * Falcao Pearl ABS script shelf # 6
#
# This script handles all scenes related in pearl ABS
#===============================================================================

module PearlScenes
  
  # Cursor icon displayed when selecting a target
  CursorIcon = 389
  
  # Status text displayed in the player selection menu
  DeathStatus =     'Death'      # Displayed when death
  BadStatus =       'Bad'        # Displayed when 0 to 25% of hp
  OverageStatus =   'Overage'    # Displayed when 25 to 50% of hp
  GoodStatus =      'Good'       # Displayed when 50 to 75% of hp
  ExellentStatus =  'Exellent'   # Displayed when 75 to 100% of hp
end

#===============================================================================
# target slection engine

class Window_EventSelect < Window_Selectable
  attr_reader   :participants
  def initialize(object)
    super(0, 0,  150, 192)
    self.z = 101
    @participants = []
    refresh(object)
    self.index = 0
    self.visible = false
    activate
  end
  
  def item
    return @data[self.index]
  end
 
  def refresh(object)
    self.contents.clear if self.contents != nil
    @data = []
    for character in object
      if character.is_a?(Game_Event)
        if character.on_battle_screen? and character.enemy_ready?
          @data.push(character)
          character.target_index = @data.size - 1
          @participants.push(character)
        end
      elsif character.on_battle_screen?
         next if character.battler.deadposing != nil and 
         $game_map.map_id != character.battler.deadposing
         @data.push(character)
         character.target_index = @data.size - 1
         @participants.push(character)
      end
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 26)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
 
  def draw_item(index)
    item = @data[index]
    x, y = index % col_max * (120 + 32), index / col_max  * 24
    self.contents.font.size = 16
    self.contents.draw_text(x + 24, y, 212, 32, 'none', 0)
  end
  
  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end 
end

# Scenen events selection target
class Scene_BattlerSelection < Scene_MenuBase
  
  def start
    super
    @mouse_exist = defined?(Map_Buttons).is_a?(String)
    item = $game_player.targeting[1]
    if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      load_target(item)
    else
      invoke = item.tool_data("Tool Invoke Skill = ")
      if invoke != 0
        load_target($data_skills[invoke])
      else
        @event_window = Window_EventSelect.new($game_map.events.values)
      end
    end
    
    # info window
    @info_window = Sprite.new
    @event_window.item.nil? ? t = 'No targets!' : t = 'Select target'
    @info_window.bitmap = Bitmap.new(300, 60)
    @info_window.z = 900 
    x, y = Graphics.width / 2 - 300 / 2,  Graphics.height / 2 - 60 / 2
    @info_window.x = x; @info_window.y = y
    @info_window.bitmap.font.size = 30
    @info_window.bitmap.font.shadow = true
    @info_window.bitmap.draw_text(0, 0, @info_window.width, 32, t, 1)
    @info_time = 60
    create_cursor unless @event_window.item.nil?
    @background_sprite.color.set(16, 16, 16, 70)
  end
  
  def create_name_sprites
    return if !@name_text.nil?
    @name_text = Sprite.new
    @name_text.bitmap = Bitmap.new(200, 60)
    @name_text.bitmap.font.size = 20
    @name_text.bitmap.font.shadow = true
    @name_text.x = @event_window.item.screen_x - 100
    @name_text.y = @event_window.item.screen_y - 58
    text = @event_window.item.battler.name
    @name_text.bitmap.draw_text(0, 0, @name_text.width, 32, text, 1)
  end
  
  def dispose_name_sprites
    return if @name_text.nil?
    @name_text.bitmap.dispose
    @name_text.dispose
    @name_text = nil
  end
  
  # load item target
  def load_target(item)
    if item.scope.between?(1, 6) 
      @event_window = Window_EventSelect.new($game_map.events.values)
    else
      targets = []
      $game_player.followers.each {|i| targets << i if i.visible?}
      targets << $game_player
      @event_window = Window_EventSelect.new(targets)
    end
  end
  
  def refresh_info(type)
    @info_window.bitmap.clear
    t = 'Invalid Target!' if type == 2
    @info_window.bitmap.draw_text(-30, 0, @info_window.width, 32, t, 1)
  end
  
  def create_cursor
    if @mouse_exist
      @cursor = $mouse_cursor
      @cursor_zooming = 0 ; update_cursor_position
      return
    end
    @cursor = Sprite.new
    icon = PearlScenes::CursorIcon
    @cursor.bitmap = Bitmap.new(24, 24)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    @cursor.bitmap.blt(0, 0, bitmap, rect)
    @cursor_zooming = 0
    update_cursor_position
  end
  
  def update
    super
    if Input.trigger?(:B)
      $game_player.targeting = [false, item=nil, char=nil]
      SceneManager.return
      Sound.play_cancel
    end
  
    @info_time -= 1 if @info_time > 0
    if @info_time == 0
      @info_window.opacity -= 8 if @info_window.opacity > 0
      if @info_window.opacity == 0 and @event_window.item.nil?
        Sound.play_cancel
        $game_player.targeting = [false, item=nil, char=nil]
        SceneManager.return
      end
    end
    return if @event_window.item.nil?
    if @mouse_exist
      for target in @event_window.participants
        if Mouse.map_grid[0] == target.x and Mouse.map_grid[1] == target.y
          @event_window.select(target.target_index)
        end
      end
    end
    
    if @current_index != @event_window.index
      @current_index = @event_window.index
      dispose_name_sprites
      create_name_sprites
    end
    
    update_cursor_position
    update_target_selection
  end
  
  # target selection
  def update_target_selection
    if Input.trigger?(:C)
      if @mouse_exist
        for event in @event_window.participants
          if Mouse.map_grid[0] == event.x and Mouse.map_grid[1] == event.y
            @event_window.select(event.target_index)
            @selected = true
          end
        end
        
        if @selected.nil?
          refresh_info(2)
          @info_time = 60; @info_window.opacity = 255
          Sound.play_buzzer
          return
        end
      end
      Sound.play_ok
      $game_player.targeting[2] = @event_window.item
      SceneManager.return
    end
  end
  
  def update_cursor_position
    if @mouse_exist
      @cursor.x = Mouse.pos[0]
      @cursor.y = Mouse.pos[1]
    else
      @cursor.x = @event_window.item.screen_x
      @cursor.y = @event_window.item.screen_y - 16
    end
    @cursor_zooming += 1
    case @cursor_zooming
    when 1..10 ; @cursor.zoom_x -= 0.01 ; @cursor.zoom_y -= 0.01
    when 11..20; @cursor.zoom_x += 0.01 ; @cursor.zoom_y += 0.01
    when 21..30; @cursor.zoom_x = 1.0   ; @cursor.zoom_y = 1.0
      @cursor_zooming = 0 
    end
  end
  
  def terminate
    super
    @event_window.dispose
    @info_window.dispose
    @info_window.bitmap.dispose
    dispose_name_sprites
    if @mouse_exist and !@cursor.nil?
      @cursor.zoom_x = 1.0   ; @cursor.zoom_y = 1.0 ; @selected = nil
    else
      @cursor.dispose unless @cursor.nil?
      @cursor.bitmap.dispose unless @cursor.nil?
    end
  end
end

#===============================================================================
#===============================================================================
# * Player slection engine

# Primary use selection
class Window_Primaryuse < Window_Command
  attr_accessor :actor
  def initialize(x, y, actor)
    @actor = actor
    super(x, y)
    deactivate ; unselect
  end
  
  def window_width()  return 544  end
  def window_height() return 80   end  

  def make_command_list
    add_command('Weapon ' + Key::Weapon[1],  'Weapon ' + Key::Weapon[1])
    add_command('Armor ' + Key::Armor[1],    'Armor ' + Key::Armor[1])
    add_command('Item '  + Key::Item[1],    'Item '  + Key::Item[1])
    add_command('Item '  + Key::Item2[1],   'Item '  + Key::Item2[1])
    add_command('Skill ' + Key::Skill[1],  'Skill ' + Key::Skill[1])
    add_command('Skill ' + Key::Skill2[1], 'Skill ' + Key::Skill2[1])
    add_command('Skill ' + Key::Skill3[1], 'Skill ' + Key::Skill3[1])
    add_command('Skill ' + Key::Skill4[1], 'Skill ' + Key::Skill4[1])
  end
  
  def refresh_actor(actor)
    @actor = actor
    refresh
  end
  
  def col_max
    return 4
  end
  
  def draw_item(index)
    contents.font.size = 20
    if @actor.primary_use == index + 1
      contents.font.color = Color.new(255, 120, 0, 255)
      draw_text(item_rect_for_text(index), command_name(index), alignment)
      change_color(normal_color, command_enabled?(index))
      return
    end
    super
  end
end

class Window_CharacterSet < Window_Selectable
  include PearlScenes
  def initialize(x=0, y=0)
    super(x, y, 544, 156)
    refresh
    self.index = 0
    activate
  end
  
  def item
    return @data[self.index]
  end
 
  def refresh
    self.contents.clear if self.contents != nil
    @data = []
    $game_party.battle_members.each {|actor| @data.push(actor)}
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 26, row_max * 128)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
 
  def draw_item(index)
    item = @data[index]
    x, y = index % col_max * (138), index / col_max  * 130
    self.contents.font.size = 20
    contents.fill_rect(x, y, item_width, item_height, Color.new(0, 0, 0, 60))
    draw_character(item.character_name, item.character_index, x + 22, y + 56)
    hp_color = [Color.new(205, 255, 205, 200),   Color.new(10, 220, 45,  200)]
    mp_color = [Color.new(180, 225, 245, 200),   Color.new(20, 160, 225, 200)]
    PearlKernel.draw_hp(self.contents, item, x + 4, y + 66, 96, 12, hp_color)
    PearlKernel.draw_mp(self.contents, item, x + 4, y + 86, 96, 12, mp_color)
    contents.draw_text(x - 2, y, item_width, 32, item.name, 2)
    contents.draw_text(x - 2, y + 20, item_width, 32, item.class.name, 2)
    case (item.hp.to_f / item.mhp.to_f * 100.0)
    when 0       ; text = DeathStatus
    when 1..25   ; text = BadStatus
    when 26..50  ; text = OverageStatus
    when 51..75  ; text = GoodStatus
    when 76..100 ; text = ExellentStatus
    end
    if item.state?(1)
      draw_icon($data_states[1].icon_index, x + 50, y + 100)
    end
    contents.draw_text(x + 4, y + 100, item_width, 32, text) rescue nil
  end
  
  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end 
  
  def col_max
    return 4
  end
  
  def line_height
    return 130
  end
end

class Scene_CharacterSet < Scene_MenuBase

  def start
    super
    x, y = Graphics.width / 2 - 544 / 2,  Graphics.height / 2 - 60 / 2
    @top_text = Window_Base.new(x, y - 170, 544, 60)
    @top_text.draw_text(0, 0, @top_text.width, 32, 'Select your Player', 1)
    @window_charset = Window_CharacterSet.new(@top_text.x, @top_text.y + 60)
    @primary_info = Window_Base.new(@top_text.x,@window_charset.y + 156, 544,60)
    @timer = 0
    refresh_primary_info('Press A to set up')
    @primary_use = Window_Primaryuse.new(@top_text.x,@primary_info.y + 60,actor)
    @primary_use.set_handler('Weapon ' + Key::Weapon[1],  method(:apply_item))
    @primary_use.set_handler('Armor '  + Key::Armor[1],   method(:apply_item))
    @primary_use.set_handler('Item '   + Key::Item[1],    method(:apply_item))
    @primary_use.set_handler('Item '   + Key::Item2[1],   method(:apply_item))
    @primary_use.set_handler('Skill '  + Key::Skill[1],   method(:apply_item))
    @primary_use.set_handler('Skill '  + Key::Skill2[1],  method(:apply_item))
    @primary_use.set_handler('Skill '  + Key::Skill3[1],  method(:apply_item))
    @primary_use.set_handler('Skill '  + Key::Skill4[1],  method(:apply_item))
    DisplayTools.create(@primary_use.x + 94, @primary_use.y + 85)
    if $game_player.in_combat_mode?
      
    end
    @index_char = @window_charset.index
    @background_sprite.color.set(16, 16, 16, 70)
  end
  
  def apply_item
    case @primary_use.current_symbol
    when 'Weapon ' + Key::Weapon[1] then actor.primary_use = 1
    when 'Armor '  + Key::Armor[1]  then actor.primary_use = 2
    when 'Item '   + Key::Item[1]   then actor.primary_use = 3
    when 'Item '   + Key::Item2[1]  then actor.primary_use = 4
    when 'Skill '  + Key::Skill[1]  then actor.primary_use = 5
    when 'Skill '  + Key::Skill2[1] then actor.primary_use = 6
    when 'Skill '  + Key::Skill3[1] then actor.primary_use = 7
    when 'Skill '  + Key::Skill4[1] then actor.primary_use = 8
    end
    refresh_primary_info(actor.name+ " now use #{@primary_use.current_symbol}!")
    @primary_use.refresh_actor(actor)
    cancel_setup; @timer = 120
  end
  
  def actor
    @window_charset.item
  end
  
  def refresh_primary_info(text)
    @primary_info.contents.clear
    @primary_info.contents.font.size = 20
    @primary_info.draw_text(0, 0, 544, 32, 'As a follower primarily use tool?')
    @primary_info.draw_text(-26, 0, 544, 32, text, 2)
  end
  
  def update
    super
    if $game_player.in_combat_mode?
      #SceneManager.return if $game_temp.pop_windowdata[0] == 4
      #return
    end
    if @timer > 0
      @timer -= 1
      refresh_primary_info('Press A to set up') if @timer == 0
    end
    DisplayTools.update
    if @index_char != @window_charset.index
      @index_char = @window_charset.index
      DisplayTools.sprite.actor = actor
      DisplayTools.sprite.refresh_icons
      DisplayTools.sprite.refresh_texts
      @primary_use.refresh_actor(actor)
    end
    update_cancel if Input.trigger?(:B)
    update_player_selection if Input.trigger?(:C)
    update_setup if Input.trigger?(:X)
  end
  
  def update_setup
    return if @primary_use.active
    Sound.play_ok
    @window_charset.deactivate
    @primary_use.activate
    @primary_use.select(0)
  end
  
  def cancel_setup
    @window_charset.activate
    @primary_use.deactivate
    @primary_use.unselect
  end
  
  def update_cancel
    Sound.play_cancel
    if @window_charset.active
      if $game_player.actor.dead?
        Sound.play_buzzer
        return
      end
      SceneManager.return
    else
      cancel_setup
    end
  end
  
  def update_player_selection
    if @window_charset.active
      if @window_charset.item.dead?
        Sound.play_buzzer
        return
      end
      Sound.play_ok
      $game_party.swap_order(0, @window_charset.index)
      SceneManager.return
    end
  end
  
  def terminate
    super
    @window_charset.dispose
    @top_text.dispose
    @primary_use.dispose
    @primary_info.dispose
    DisplayTools.dispose
  end
end

#===============================================================================
#===============================================================================
# * Quick tool se3lection engine

class Window_Base < Window
  def draw_text_ex2(x, y, text)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
end

# window horizon
class Window_ItemSelect < Window_HorzCommand
  def initialize(x=0, y=0)
    super(x, y)
  end
  
  def window_width()  return 460  end
  def window_height() return 50   end  

  def make_command_list
    add_command("Weapons",  :weapon)
    add_command("Left Hand",   :armor)
    add_command("Items",    :item)
    add_command("Skills",   :skill)
  end
  
  def draw_item(index)
    contents.font.size = 20
    super
  end
end

# window slot ask
class Window_SlotConfirm < Window_Command
  def initialize(x, y, kind)
    @kind = kind
    super(x, y)
    activate
  end
  
  def window_width()  return 130  end
  def window_height() return @kind == :item ? 80 : 120   end  

  def make_command_list
    case @kind
    when :item
      add_command('Slot ' + Key::Item[1],    :slot1)
      add_command('Slot ' + Key::Item2[1],   :slot2)
    when :skill
      add_command('Slot ' + Key::Skill[1],   :slot1)
      add_command('Slot ' + Key::Skill2[1],  :slot2)
      add_command('Slot ' + Key::Skill3[1],  :slot3)
      add_command('Slot ' + Key::Skill4[1],  :slot4)
    end
  end
  
  def draw_item(index)
    contents.font.size = 20
    super
  end
end

# Actor quick tool
class Window_ActorQuickTool < Window_Selectable
  def initialize(x=0, y=124, w=460, h=148)
    super(x, y,  w, h)
    unselect
  end
  
  def item()        return @data[self.index] end
  def col_max()     return 2                 end
  def spacing()     return 6                 end  
  
  def refresh(actor, kind)
    self.contents.clear if self.contents != nil
    @data = []
    if kind == :weapon
      operand = $game_party.weapons
      operand.push(actor.equips[0]) if actor.equips[0] != nil
    end
    if kind == :armor
      operand = $game_party.armors 
      operand.push(actor.equips[1]) if actor.equips[1] != nil
    end
    operand = $game_party.items if kind == :item
    operand = actor.skills if kind == :skill
    for item in operand
      if kind == :weapon || kind == :armor
        next unless actor.equippable?(item)
        next if item.etype_id > 1
      end
      
      unless @data.include?(item)
        next if item.tool_data("Exclude From Tool Menu = ", false) == "true"
        @data.push(item) 
      end
      
      
      
      
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 24)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
 
  def draw_item(index)
    item = @data[index]
    x, y = index % col_max * (190 + 32), index / col_max  * 24
    self.contents.font.size = 20
    draw_icon(item.icon_index, x, y)
    contents.draw_text(x + 24, y, 212, 32, item.name)
  end
  
  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end 
end

module DisplayTools
  
  def self.create(x, y)
    @viewport2 = Viewport.new ; @viewport2.z = 999
    @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2, [x, y])
  end
  
  def self.sprite
    return @pearl_tool_sprite
  end
  
  def self.update
    @pearl_tool_sprite.update
  end
  def self.dispose
    @pearl_tool_sprite.dispose ; @viewport2.dispose
    @viewport2 = nil ; @pearl_tool_sprite = nil
  end
end


# Scene quick tool
class Scene_QuickTool < Scene_MenuBase
  
  def start
    super
    x, y = Graphics.width / 2 - 460 / 2,  Graphics.height / 2 - 85 / 2
    @top_text = Window_Base.new(x, y - 156, 460, 85)
    @statust = ['Ready', 0]
    refresh_top_info
    @type_select = Window_ItemSelect.new(@top_text.x, @top_text.y + 85)
    @type_select.set_handler(:weapon,     method(:refresh_tools))
    @type_select.set_handler(:armor,      method(:refresh_tools))
    @type_select.set_handler(:item,       method(:refresh_tools))
    @type_select.set_handler(:skill,      method(:refresh_tools))
    @type_select.set_handler(:cancel,     method(:refresh_cancel))
    @type_index = @type_select.index
    @items_w = Window_ActorQuickTool.new(@type_select.x, @type_select.y + 50)
    @items_w.refresh($game_player.actor, @type_select.current_symbol)
    @description = Window_Base.new(@items_w.x, @items_w.y + 148, 460, 75)
    DisplayTools.create(@description.x + 75, @description.y + 80)
    @background_sprite.color.set(16, 16, 16, 70)
  end
  
  # create slot confirm
  def create_slot_confirm
    @slot_confirm = Window_SlotConfirm.new(@items_w.x + 144, @items_w.y + 36, 
    @type_select.current_symbol)
    if @type_select.current_symbol == :item
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
    else
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
      @slot_confirm.set_handler(:slot3,     method(:open_slots))
      @slot_confirm.set_handler(:slot4,     method(:open_slots))
    end
  end
  
  # dispose slot confirm
  def dispose_slot_confirm
    return if @slot_confirm.nil?
    @slot_confirm.dispose
    @slot_confirm = nil
  end
  
  # top info
  def refresh_top_info
    @top_text.contents.clear
    @top_text.contents.font.size = 20
    @top_text.contents.fill_rect(0, 0, 58, 74, Color.new(0, 0, 0, 60))
    @top_text.draw_character(actor.character_name,actor.character_index, 26, 60)
    @top_text.draw_text(62, 0, @top_text.width, 32, actor.name + ' Equippment')
    @top_text.draw_text(62, 22, @top_text.width, 32, actor.class.name)
    @top_text.draw_text(-22, 30, @top_text.width, 32, @statust[0], 2)
    @top_text.draw_text(-22, 0,@top_text.width,32, 'M = Switch Player',2) unless
    PearlKernel::SinglePlayer
  end
  
  def refresh_tools
    enable_items
  end
  
  def refresh_cancel
    SceneManager.return
  end
  
  def enable_items
    @items_w.activate
    @items_w.select(0)
  end
  
  def refresh_description
    @description.contents.clear
    @desc_index = @items_w.index
    return if @items_w.item.nil? || @items_w.index < 0
    @description.contents.font.size = 20
    @description.draw_text_ex2(0, -4, @items_w.item.description)
  end

  def update
    super
    perform_item_ok if Input.trigger?(:C)
    perform_canceling if Input.trigger?(:B)
    if PearlKey.trigger?(Key::PlayerSelect) and !PearlKernel::SinglePlayer
      Sound.play_ok
      SceneManager.call(Scene_CharacterSet)
    end
    DisplayTools.update
    perform_refresh
  end
  
  def perform_item_ok
    return if @items_w.item.nil?
    case @type_select.current_symbol
    when :weapon
      actor.change_equip_by_id(0, @items_w.item.id)
      equip_play
    when :armor
      actor.change_equip_by_id(1, @items_w.item.id)
      equip_play
    when :item
      activate_slots
    when :skill
      activate_slots
    end
    DisplayTools.sprite.refresh_texts
  end
  
  def activate_slots
    @items_w.deactivate
    create_slot_confirm
    Sound.play_ok
  end
  
  def deactivate_slots
    @items_w.activate
    dispose_slot_confirm
  end
  
  def actor
    return $game_player.actor
  end
  
  def equip_play
    Sound.play_equip
    @statust[1] = 80
  end
  
  # open slots
  def open_slots
    if @type_select.current_symbol == :item
      case @slot_confirm.current_symbol
      when :slot1 then actor.assigned_item  = @items_w.item
      when :slot2 then actor.assigned_item2 = @items_w.item
      end
    else
      case @slot_confirm.current_symbol
      when :slot1 then actor.assigned_skill  = @items_w.item
      when :slot2 then actor.assigned_skill2 = @items_w.item
      when :slot3 then actor.assigned_skill3 = @items_w.item
      when :slot4 then actor.assigned_skill4 = @items_w.item
      end
    end
    equip_play ; deactivate_slots
    DisplayTools.sprite.refresh_texts
  end
  
  def perform_canceling
    Sound.play_cancel
    if @items_w.active
      @items_w.deactivate
      @items_w.unselect
      @type_select.activate
    else
      deactivate_slots
    end
  end
  
  def perform_refresh
    if @type_index != @type_select.index
      @type_index = @type_select.index
      @items_w.refresh($game_player.actor, @type_select.current_symbol)
      refresh_description
    end
    if @desc_index != @items_w.index
      @desc_index = @items_w.index
      refresh_description
    end
    if @statust[1] > 0 
      @statust[1] -= 1 
      if @statust[1] == 78
        @statust[0] = @items_w.item.name + ' Equipped'
        refresh_top_info
      elsif @statust[1] == 0
        @statust = ['Ready', 0]
        refresh_top_info
      end
    end
  end
  
  def terminate
    super
    @top_text.dispose
    @type_select.dispose
    @items_w.dispose
    @description.dispose
    dispose_slot_confirm
    DisplayTools.dispose
  end
  
end