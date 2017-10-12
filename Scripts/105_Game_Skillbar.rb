#===============================================================================
# * PONY::SkillBar
#-------------------------------------------------------------------------------
#   Tool/SkillBar Set up 
#===============================================================================
# tag: hotkey
# tag: skillbar
module PONY::SkillBar
  # Layout graphic
  LayoutImage = "Skillbar"
  
  # Follower attack command icon index
  FollowerIcon      = 11
  FollowerFightIcon = 116
  
  AllSkillIcon = 143
  VancianIcon  = 141
  AllItemIcon  = 1528
  
  PrevPageIcon  = 2238
  NextPageIcon  = 2237
  CancelIcon    = 1142
  
  HotKeySelection = 1
  AllSelection    = 2
  CastSelection   = 3
  
  Follower_Flag = "$game_player.followers.combat_mode? ? FollowerFightIcon : FollowerIcon"
  AllItem_Flag  = AllItemIcon
  AllSkill_Flag = AllSkillIcon
  Vancian_Flag  = VancianIcon
  
  PrevPage_Flag = PrevPageIcon
  NextPage_Flag = NextPageIcon
  Cancel_Flag   = CancelIcon
  
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
  
  Follower_Flag.trust
  Follower_Flag.untaint
end
#===============================================================================
# * HotKeys
#-------------------------------------------------------------------------------
#   Hot Key Settings
#===============================================================================
module HotKeys
  
  Weapon       = :kR
  Armor        = :kF
  HotKeys      = [:k1, :k2, :k3, :k4, :k5, :k6, :k7, :k8, :k9, :k0]
  AllSkills    = :kTILDE
  AllItems     = :kMINUS
  Vancians     = :kEQUAL
  SwitchMember = [:kF3, :kF4, :kF5]
  QuickSave    = :kF7
  QuickLoad    = :kF8
  Follower     = :kC
  
  SkillBar     = [Weapon, Armor, Follower, AllSkills, HotKeys, AllItems, Vancians].flatten
  SkillBarSize = SkillBar.size
  HotkeyStartLoc = 4
  
  Menu         = :kESC
  Journal      = :kJ
  Inventory    = :kI
  Talents      = :kT
  Pause        = :kSPACE
  
  Letter = {
    :kCOLON => ':',        :kAPOSTROPHE => 39.chr, :kQUOTE => 39.chr,
    :kCOMMA => ',',        :kPERIOD => '.',        :kSLASH => 47.chr,
    :kBACKSLASH => 92.chr, :kLEFTBRACE => '(',     :kRIGHTBRACE => ')',
    :kMINUS => '-',        :kUNDERSCORE => '_',    :kPLUS => '+',
    :kEQUAL => '=',        :kEQUALS => '=',        :kTILDE => '~',
  }
  
  def self.name(key)
    Letter.each do  |name, ch|
      return ch if key == name
    end
    base = key.to_s
    base = base[1].upcase + base[2...base.length].downcase
    return base
  end
  
  def self.tool_index(key)
    return if key.nil?
    n = SkillBar.size
    for i in 0...n
      return i if key == SkillBar[i]
    end
  end
  
  def self.assigned_hotkey_index(index)
    return index - HotkeyStartLoc
  end
  
end
#===============================================================================
# * Game_SkillBar
#-------------------------------------------------------------------------------
#   Skill bar object that handle the actions triggered in skillbar.
#===============================================================================
#tag: skillbar
#tag: hotkey
class Game_Skillbar
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Phase_Map           = 0
  Phase_Selection     = 1
  #--------------------------------------------------------------------------
  # *) Instance Vars
  #--------------------------------------------------------------------------
  attr_accessor :x, :y, :z
  attr_accessor :actor 
  attr_accessor :stack
  attr_accessor :sprite
  attr_accessor :items
  attr_accessor :monitor
  attr_accessor :phase
  attr_accessor :edit_enabled
  attr_accessor :index
  attr_accessor :need_refresh
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize(phase = 0)
    @actor          = nil
    @last_actor_id  = 0
    @stack          = []
    @items          = []
    @pages          = []
    @current_page   = 0
    @index          = nil
    @col_max        = HotKeys::SkillBarSize
    @monitor        = nil
    @dragging_index = nil
    @dragging_item  = nil
    @edit_enabled   = false
    @phase          = phase
    @need_refresh   = true
    @displayed_help = nil
    @x = @y = 0
    @z = 500
    clear_page
  end
  #--------------------------------------------------------------------------
  def create_layout(viewport, phase = nil)
    @sprite = Sprite_Skillbar.new(viewport, self)
    @phase  = phase if phase
    @phase  = SceneManager.scene_is?(Scene_Map) ? 0 : 1 unless phase
    @x, @y  = @sprite.x, @sprite.y
    debug_print "Create skillbar"
    refresh
  end
  #--------------------------------------------------------------------------
  def dispose_layout
    return unless sprite_valid?
    @sprite.dispose
    debug_print "Dispose skillbar"
    @sprite = nil
  end
  alias dispose dispose_layout
  #--------------------------------------------------------------------------
  # *) Object Update
  #--------------------------------------------------------------------------
  def update
    current_actor = determine_actor
    refresh_item           if @need_refresh
    refresh(current_actor) if refresh_needed?(current_actor)
    process_input  unless $game_system.story_mode?
    update_edit    if @edit_enabled
    @sprite.update if sprite_valid?
  end
  #--------------------------------------------------------------------------
  def refresh_needed?(current_actor)
    return false if @phase != Phase_Map
    return true  if $game_map.need_refresh
    return false if current_actor.id == @last_actor_id
    return true
  end
  #--------------------------------------------------------------------------
  # * Updates when edit mode is enabled
  #--------------------------------------------------------------------------
  def update_edit
    update_dragging if @dragging_item
    drag_select unless @dragging_item
  end
  #--------------------------------------------------------------------------
  # * Monitoring the item to be dragged
  #--------------------------------------------------------------------------
  def drag_select
    return unless index = get_monitor
    return unless @items[index] && !@items[index].is_a?(Numeric)
    @sprite.drag_icon(index)
    @dragging_item  = @items[index]
    @dragging_index = index
    clear_index(index)
  end
  #--------------------------------------------------------------------------
  # * Update the dragged item
  #--------------------------------------------------------------------------
  def update_dragging
    return unless Mouse.click?(1)
    index = get_monitor
    determine_destination(index)
  end
  #--------------------------------------------------------------------------
  # *) Refresh
  #--------------------------------------------------------------------------
  def refresh(actor = determine_actor)
    @actor = actor
    @last_actor_id = @actor.id
    @stack.clear
    @stack << @actor
    refresh_item
  end
  #--------------------------------------------------------------------------
  # *) Refresh items
  #--------------------------------------------------------------------------
  def refresh_item
    @need_refresh = false
    @current_page = 0
    hotkey_items  = @actor.get_hotkeys
    @primary_tool = hotkey_items.first
    clear_page
    #debug_print("Skillbar stack size: #{@stack.size}")
    case @stack.size
    when HotKeySelection
      #debug_print "Refresh hotkey selection"
      @first_scan_index = 0
      @items = hotkey_items
      @items.push(AllItem_Flag)
      @items.push(Vancian_Flag)
      @items.insert(2, AllSkill_Flag)
      @items.insert(2, Follower_Flag)
      @sprite.refresh if sprite_valid?
    when AllSelection
      #debug_print "Refresh hotkey bar page #{@current_page}"
      @items = @actor.get_hotkeys(true)
      @items.push(Follower_Flag)
      divide_pages(@actor.get_valid_skills)     if @stack.last == AllSkill_Flag
      divide_pages($game_party.get_valid_items) if @stack.last == AllItem_Flag
      divide_pages(@actor.get_vancian_spells)   if @stack.last == Vancian_Flag
      refresh_page
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh current page items
  #--------------------------------------------------------------------------
  def refresh_page
    @items.pop until @items.last == Follower_Flag
    @items.push(PrevPage_Flag)
    @pages[@current_page].each do |item|
      @items.push(item)
    end
    @items.push(NextPage_Flag)
    @items.push(Cancel_Flag)
    @sprite.refresh if sprite_valid?
  end
  #--------------------------------------------------------------------------
  # * Clear page for all selection
  #--------------------------------------------------------------------------
  def clear_page
    @pages.clear
    @pages[0] = Array.new(10)
  end
  #--------------------------------------------------------------------------
  # * Determine skillbar display for which actor
  #--------------------------------------------------------------------------
  def determine_actor
    return @actor       if @actor && @phase == Phase_Selection
    return $game_player if @phase == Phase_Map
  end
  #--------------------------------------------------------------------------
  # *) Process Input
  #--------------------------------------------------------------------------
  def process_input
    return unless button_cooled?
    if Mouse.click?(1) && !Mouse.hover_UI? && SceneManager.scene_is?(Scene_Map) &&
      !SceneManager.tactic_enabled?
      process_item_use(@primary_tool)
    elsif Mouse.click?(2) && @stack.size > HotKeySelection
      fallback
    elsif !Input.press?(:kCTRL)
      for i in @first_scan_index...HotKeys::SkillBarSize
        select(i)    if Input.trigger?(HotKeys::SkillBar[i]) || Mouse.trigger_skillbar?(i)
        show_item_help(i) if Mouse.hover_skillbar?(i) && Input.trigger?(:kTAB)
      end
    end
  end
  #--------------------------------------------------------------------------
  # *) Select item
  #--------------------------------------------------------------------------
  def select(index)
    #debug_print("Hotkey Bar selected: #{index} (#{@items[index]})")
    select_hotkey(index)
    heatup_button
  end
  #--------------------------------------------------------------------------
  # *) Select item in hotkey phase
  #--------------------------------------------------------------------------
  def select_hotkey(index)
    if @phase == Phase_Map
      case @items[index]
      when AllSkill_Flag;   return process_skill_select;
      when AllItem_Flag;    return process_item_select;
      when Vancian_Flag;    return process_vancian_select;
      when PrevPage_Flag;   return page_previous;
      when NextPage_Flag;   return page_next;
      when Cancel_Flag;     return fallback;
      end
      return process_follower_action if Follower_Flag == @items[index]
    end
    @monitor = index if @phase == Phase_Selection && !@items[index].is_a?(Fixnum) && !@items[index].is_a?(String)
    return process_item_use(@items[index]) if @phase == Phase_Map
  end
  #--------------------------------------------------------------------------
  # *) Max items per page
  #--------------------------------------------------------------------------
  def page_item_max
    # @col_max = SkillBarSize (16)
    # 6 = Weapon, Armor, Follower, next/previous page + cancel    
    return @col_max - 6
  end
  #--------------------------------------------------------------------------
  # *) Partation items into each page
  #--------------------------------------------------------------------------
  def divide_pages(all_data)
    @pages.clear
    @pages[0] = Array.new(10) # prevent nothing can be used
    all_data.each_with_index do |item, index|
      @pages[index / 10] = Array.new(10) if !@pages[index / 10]
      @pages[index / 10][index % 10] = item
    end
  end
  #--------------------------------------------------------------------------
  def process_skill_select
    @stack.push(AllSkill_Flag)
    refresh_item
  end
  #--------------------------------------------------------------------------
  def process_item_select
    @stack.push(AllItem_Flag)
    refresh_item
  end
  #--------------------------------------------------------------------------
  def process_vancian_select
    @stack.push(Vancian_Flag)
    refresh_item
  end
  #--------------------------------------------------------------------------
  def process_follower_action
    $game_player.followers.toggle_combat
  end
  #--------------------------------------------------------------------------
  def process_item_use(item)
    if !item.nil? && @actor.item_test(@actor, item)
      @actor.process_tool_action(item)
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  def fallback
    case @stack.size
    when AllSelection
      @stack.pop
      refresh_item
    when CastSelection
      
    end
  end
  #--------------------------------------------------------------------------
  def page_next
    @current_page += 1 if next_page_available?
    refresh_page
  end
  #--------------------------------------------------------------------------
  def page_previous
    @current_page -= 1 if prev_page_available?
    refresh_page
  end
  #--------------------------------------------------------------------------
  def next_page_available?
    return @current_page + 1 < @pages.size
  end
  #--------------------------------------------------------------------------
  def prev_page_available?
    return @current_page - 1 > 0
  end
  #--------------------------------------------------------------------------
  def cancel_edit(continue = false)
    @sprite.release_drag
    @edit_enabled   = continue
    resume_dragging_item if !continue
    @dragging_item  = nil
    @dragging_index = nil
    refresh
  end
  #--------------------------------------------------------------------------
  def resume_dragging_item
    return unless @dragging_item
    true_index = HotKeys.assigned_hotkey_index(@dragging_index)
    @actor.assigned_hotkey[true_index] = @dragging_item
  end
  #--------------------------------------------------------------------------
  def determine_destination(index)
    if index && hotkey_index?(index)
      new_index = HotKeys.assigned_hotkey_index(index)
      prev_index   = HotKeys.assigned_hotkey_index(@dragging_index)
      @actor.assigned_hotkey[prev_index], @actor.assigned_hotkey[new_index] =
      @actor.assigned_hotkey[new_index], @dragging_item
    end
    refresh
    cancel_edit(true)
  end
  #--------------------------------------------------------------------------
  def clear_index(index)
    @actor.assigned_hotkey[HotKeys.assigned_hotkey_index(index)] = nil
    refresh
  end
  #--------------------------------------------------------------------------
  def hotkey_index?(index)
    return HotKeys::HotKeys.include?(HotKeys::SkillBar[index])
  end
  #--------------------------------------------------------------------------
  def get_monitor
    return unless @monitor
    re = @monitor
    @monitor = nil
    return re
  end
  #--------------------------------------------------------------------------
  def unselect
    return unless sprite_valid?
    @sprite.unselect
  end
  #--------------------------------------------------------------------------
  def hide
    return unless sprite_valid?
    @sprite.hide
  end
  #--------------------------------------------------------------------------
  def show
    return unless sprite_valid?
    @sprite.show
  end
  #--------------------------------------------------------------------------
  def visible?
    return unless sprite_valid?
    return @sprite.visible?
  end
  #--------------------------------------------------------------------------
  def sprite_valid?
    return @sprite && !@sprite.disposed?
  end
  #--------------------------------------------------------------------------
  def show_item_help(index)
    pos = Mouse.pos
    mx, my = *pos
    mx = [Graphics.width - 120, mx].min
    my = [Graphics.height - 68, my].min
    info = get_help_text(index)
    SceneManager.show_item_help_window(mx, my, info)
  end
  #--------------------------------------------------------------------------
  def get_help_text(index)
    if @items[index].is_a?(Fixnum)
      case @items[index]
      when AllSkill_Flag;   return "All sklls";
      when Vancian_Flag;    return "Vancian spells";
      when AllItem_Flag;    return "All items";
      when PrevPage_Flag;   return "Previous page";
      when NextPage_Flag;   return "Next page";
      when Cancel_Flag;     return "Cancel";
      end
    elsif @items[index].is_a?(String) && @items[index] == Follower_Flag
      return "Toggle party combat mode"
    elsif @items[index].is_a?(RPG::BaseItem)
      return @items[index].name
    end
    return "~Nothing is here~"
  end
  #--------------------------------------------------------------------------
  # * Start button cooldown
  #--------------------------------------------------------------------------
  def heatup_button(multipler = 1)
    SceneManager.scene.heatup_button(multipler) rescue false
  end
  #--------------------------------------------------------------------------
  # * Button cooldown finished
  #--------------------------------------------------------------------------
  def button_cooled?
    SceneManager.scene.button_cooled? rescue false
  end
end
