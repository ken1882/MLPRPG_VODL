#===============================================================================
# * Game_SkillBar
#-------------------------------------------------------------------------------
#   Skill bar object that handle the actions triggered in skillbar.
#===============================================================================
#tag: 2
class Game_Skillbar
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  Phase_Map       = 0
  Phase_Selection = 1
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
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize(phase = 0)
    @actor          = nil
    @last_actor_id  = 0
    @stack          = []
    @items          = []
    @index          = HotKeys::SkillBar
    @tol_col        = HotKeys::SkillBarSize
    @bot_col        = 0
    @monitor        = nil
    @dragging_index = nil
    @dragging_item  = nil
    @edit_enabled   = false
    @phase          = phase
    @x = @y = 0
    @z = 0
  end
  #--------------------------------------------------------------------------
  def create_layout(viewport, phase = nil)
    @sprite = Sprite_Skillbar.new(viewport, self)
    @phase  = phase if phase
    @phase  = SceneManager.scene_is?(Scene_Map) ? 0 : 1 unless phase
    @x, @y  = @sprite.x, @sprite.y
    debug_print "Create skillbar"
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
    refresh if @phase == Phase_Map && @last_actor_id == $game_player.id
    process_input
    update_edit    if @edit_enabled
    @sprite.update if sprite_valid?
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
    @actor  = actor
    @last_actor_id = @actor.id
    @skills = @actor.skills
    @usableitems = $game_party.items
    @stack.clear
    @stack[0] = @actor
    refresh_item
    @sprite.refresh if sprite_valid?
  end
  #--------------------------------------------------------------------------
  # *) Refresh items
  #--------------------------------------------------------------------------
  def refresh_item
    case @stack.size
    when HotKeySelection
      @first_scan_index = 0
      @items = @actor.get_hotkeys
      @items.push(AllItem_Flag)
      @items.push(Vancian_Flag)
      @items.insert(2, AllSkill_Flag)
      @items.insert(2, Follower_Flag)
    when AllSelection || CastSelection
      # under contruction
    end
    @sprite.refresh if sprite_valid?
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
    for i in @first_scan_index...HotKeys::SkillBarSize
      select(i) if Input.trigger?(HotKeys::SkillBar[i]) || Mouse.trigger_skillbar?(i)
    end
  end
  #--------------------------------------------------------------------------
  # *) Select item
  #--------------------------------------------------------------------------
  def select(index)
    debug_print "Skillbar selected: #{index} #{@items[index]}"
    case @stack.size
    when HotKeySelection
      @bot_col = select_hotkey(index)
    when AllSelection || CastSelection
      
    end
  end
  #--------------------------------------------------------------------------
  # *) Select item in hotkey phase
  #--------------------------------------------------------------------------
  def select_hotkey(index)
    return process_skill_select     if @items[index] == AllSkill_Flag && @phase == Phase_Map
    return process_item_select      if @items[index] == AllItem_Flag  && @phase == Phase_Map
    return process_vancian_select   if @items[index] == Vancian_Flag  && @phase == Phase_Map
    return process_follower_action  if @items[index] == Follower_Flag && @phase == Phase_Map
    @monitor = index if @phase == Phase_Selection
    return process_item_use(@items[index]) if @phase == Phase_Map
  end
  #--------------------------------------------------------------------------
  def process_skill_select
    return 0
    #tag: queued
    @stack.push(AllSkill_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_item_select
    return 0
    @stack.push(AllItem_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_vancian_select
    # tag: under construction
    return 0
    @stack.push(Vancian_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_follower_action
    $game_player.followers.into_fray
  end
  #--------------------------------------------------------------------------
  def process_item_use(item)
    @actor.process_tool_action(item)
  end
  #--------------------------------------------------------------------------
  def cancel_edit(continue = false)
    @sprite.release_drag
    @edit_enabled   = continue
    @dragging_item  = nil
    @dragging_index = nil
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
  def phase; @stack.size; end
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
  
end
# last work: drag icon
# queued work
