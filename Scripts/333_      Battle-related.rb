class Game_Action
  
  def spell_slot
    @spell_slot
  end
  
  def spell_slot=(x)
    @spell_slot = x;
  end
  
  def set_spell_slot(slot)
    @spell_slot = slot;
  end
  
end
module BattleManager
  class << self
    alias_method  :vancecs_battle_start, :battle_start
    def battle_start
      VancianCS.lock_in_all_spell_slots
      vancecs_battle_start
    end
  end
end
class Scene_Battle < Scene_Base
    
  def activate_spellbook
    $game_variables[9] = 1
  end
  
  def deactivate_spellbook
    $game_variables[9] = 0
  end
    
  
  alias_method  :vancecs_create_all_windows, :create_all_windows
  def create_all_windows
    vancecs_create_all_windows
    create_spellbook_window
    create_spell_info_window
    VancianCS.lock_in_all_spell_slots
  end
  
  alias_method  :vancecs_create_actor_command_window, :create_actor_command_window
  def create_actor_command_window
    vancecs_create_actor_command_window
    @actor_command_window.set_handler(:spellbook,  method(:command_spellbook))
  end
  
  def create_spellbook_window
    height = Graphics.height - @help_window.height
    @spellbook_window = Window_Spellbook.new(0, @help_window.height, height, @actor, true)
    @spellbook_window.hide
    @spellbook_window.set_handler(:ok,     method(:on_spellbook_ok))
    @spellbook_window.set_handler(:cancel, method(:on_spellbook_cancel))
    @spellbook_window.help_window = @help_window
  end
  
  def create_spell_info_window
    x = @spellbook_window.width
    y = @help_window.height
    @spellbookhelp_window =
      Window_SpellbookInfo.new(x, y, 3)
    @spellbookhelp_window.hide
    @spellbookhelp_window.deactivate
    @spellbookhelp_window.category = "arcane"
    @spellbook_window.info_window = @spellbookhelp_window
  end
  
  # colossal violation of DRY
  def on_spellbook_ok
    
    @selected_spell = @spellbook_window.current_element
    @skill = $data_skills[@selected_spell[2][:spell_id]]
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.input.set_spell_slot(@selected_spell);
    BattleManager.actor.last_skill.object = @skill
    
    if !@skill.need_selection?
      @spellbook_window.hide
      @help_window.hide
      @spellbookhelp_window.hide
      next_command
      if @skill.for_opponent?
        select_enemy_selection
      else
        select_actor_selection
      end
    elsif @skill.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  
  def on_spellbook_cancel
    return if BattleManager.actor == nil
    #$game_variables[9] = 0
    @help_window.hide
    @spellbook_window.hide
    @spellbookhelp_window.hide
    @actor_command_window.activate
    start_actor_command_selection
  end
  
  def command_spellbook
    @spellbook_window.refresh
    create_spellbook_window
    create_spell_info_window
    VancianCS.lock_in_all_spell_slots
    @skill_window.stype_id = @actor_command_window.current_ext
    @help_window.show
    @spellbookhelp_window.show
    @spellbookhelp_window.actor = BattleManager.actor
    @spellbookhelp_window.category = BattleManager.actor.casting_category
    @spellbook_window.actor = BattleManager.actor
    @spellbook_window.show.activate
    $mog_actor_window_hide = true
    activate_spellbook
  end
  
  alias_method  :vancecs_on_actor_ok, :on_actor_ok
  def on_actor_ok
    vancecs_on_actor_ok
    @spellbook_window.hide
    @spellbookhelp_window.hide
    @help_window.hide
    $mog_actor_window_hide = false
    deactivate_spellbook
  end
  
  alias_method  :vancecs_on_enemy_ok, :on_enemy_ok
  def on_enemy_ok
    vancecs_on_enemy_ok
    @spellbook_window.hide
    @spellbookhelp_window.hide
    @help_window.hide
    $mog_actor_window_hide = false
    deactivate_spellbook
  end
  
  alias_method  :vancecs_on_actor_cancel, :on_actor_cancel
  def on_actor_cancel
    vancecs_on_actor_cancel
    if @actor_command_window.current_symbol == :spellbook
      @spellbook_window.show.activate
      @help_window.show
    end
  end
  
  alias_method  :vancecs_on_enemy_cancel, :on_enemy_cancel
  def on_enemy_cancel
    vancecs_on_enemy_cancel
    if @actor_command_window.current_symbol == :spellbook
      @spellbook_window.show.activate
      @help_window.show
    end
  end
  
  def spell_slot
    @spell_slot
  end
  
  alias_method  :vancecs_use_item, :use_item
  def use_item
    vancecs_use_item
    if @subject.current_action != nil then
      spell = @subject.current_action.spell_slot 
    end
    
    if(spell)then
      # only the spot position matters for this; more robust handling
      #  would definitely be nice in the future
      @subject.use_slot_at_xy(spell[0], spell[1]);
    end
  end
end
class Window_ActorCommand < Window_Command
  alias_method  :vancian_cs_add_skill_commands, :add_skill_commands
  def add_skill_commands
    vancian_cs_add_skill_commands
    
    if(@actor.has_vancian_casting?)
      # Extend this in the future to allow for easy multiclassing
      # there's an extra optional fourth arg to pass arbitrary data
      add_command(VancianCS::MENU_SPELLBOOK_TERM, :spellbook, true)
    end
  end
end
