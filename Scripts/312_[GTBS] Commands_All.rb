#=============================================================
# Commands All
#-------------------------------------------------------------
#This displays the command window for character actions.
#=============================================================
class Commands_All < TBS_Win_Actor
  
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(*args)
    super
    self.x = 50
    self.y = 50
    @actor_display = Window_Actor_Display.new(height)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    scene = SceneManager.scene
    return unless scene.is_a?(Scene_Map)
    return unless scene.button_cooled?
    
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_move_command
    add_hold_command
    #add_swap_command
    #add_attack_command
    #add_skill_commands
    #add_item_command
    #add_guard_command
    #add_equip_command if $imported["YEA-CommandEquip"]
    #add_status_command
    #add_escape_command
  end
  #--------------------------------------------------------------------------
  # * Add Move Command to List
  #--------------------------------------------------------------------------
  def add_move_command
    add_command(GTBS::Menu_Move, :move, @battler.is_a?(Game_Follower))# unless GTBS::HIDE_INACTIVE_COMMANDS && @actor.moved?
  end
  
  def add_hold_command
    add_command("Hold/Unhold", :hold, @battler.is_a?(Game_Follower))
  end
  
  def add_swap_command
    add_command("Swap Control", :swap, @battler.is_a?(Game_Follower) && !@battler.dead?)
  end
  def add_status_command
    add_command(Vocab.status, :status, true)
  end
  
  def add_escape_command
    add_command(Vocab.escape, :escape, BattleManager.can_escape?)
  end
  #--------------------------------------------------------------------------
  # * Add Attack Command to List
  #--------------------------------------------------------------------------
  def add_attack_command(disabled=false)
    add_command((GTBS::Use_Weapon_Name_For_Attack ? @actor.weapon_name : Vocab::attack), :attack, @actor.attack_usable?)
  end
  #--------------------------------------------------------------------------
  # * Add Skill Command to List
  #--------------------------------------------------------------------------
  def add_skill_commands(disabled)
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Add Item Command to List
  #--------------------------------------------------------------------------
  def add_item_command(disabled)
    add_command(Vocab::item, :item)
  end
  #--------------------------------------------------------------------------
  # * Add Guard Command to List
  #--------------------------------------------------------------------------
  def add_guard_command
    if @actor.perfaction? == false#@actor.guard_usable?
      add_command(Vocab::guard, :defend, true)
    else
      add_command(GTBS::Menu_Wait, :wait, true)
    end
  end
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup(actor, battler)
    @battler = battler
    super(actor)
    @actor_display.refresh(actor)
    self.height = item_max * WLH + (standard_padding * 2)
    select(0)
    self.move_to(6)
    self.y = 155
  end
  #--------------------------------------------------------------------------
  def clear_help
    if @help_window
      @help_window.clear
    end
  end
  #--------------------------------------------------------------------------
  def call_update_help
    update_help if @help_window
  end
  #--------------------------------------------------------------------------
  def update_help
    case current_symbol
    when :item
      text = Vocab_GTBS::Help_Item
    when :skill
      text = Vocab_GTBS::Help_Class_Ability
    when :attack
      text = Vocab_GTBS::Help_Attack
    when :move
      text = Vocab_GTBS::Help_Move
    when :status
      text = Vocab_GTBS::Help_Status
    when :defend
      text = Vocab_GTBS::Help_Defend
    when :wait
      text = Vocab_GTBS::Help_Wait
    when :escape
      text = Vocab_GTBS::Help_Escape
    end
    text = (text || "")
    
    #This is a kludge to make this help window display correctly
    @help_window.move_to(8)
    @help_window.move_to(2)
    #for whatever reason, it must be moved then, moved back to start displaying
    #text again. ???
    @help_window.set_text(text)
  end
end
