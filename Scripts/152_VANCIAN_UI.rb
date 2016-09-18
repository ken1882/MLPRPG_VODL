# HERE BE DRAGONS!
# documentation and comments are minimal from here on out


# TODO: Handle QW scrolling
# TODO: Ready some plumbing for metamagic.

class Scene_Vancian < Scene_ItemBase
  attr_reader :category
  
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    
    @category = "arcane"; # arcane is just a default string for now; i'll have
                          # have to refactor in some more robust behaviour later
    if @actor && @actor.has_vancian_casting?
      @category = @actor.casting_category
    end
    
    create_help_window
    create_spellbook_window
    create_spellbookhelp_window
    create_level_window
    create_item_window
    
    look_at_spellbook_slot
  end
  
  def create_spellbook_window
    
    height = Graphics.height - @help_window.height
    @spellbook_window = Window_Spellbook.new(0, @help_window.height, height, @actor)
    @spellbook_window.activate
    @spellbook_window.set_handler(:ok,     method(:choose_spellbook_slot))
    @spellbook_window.set_handler(:cancel, method(:exit_spellbook))
    @spellbook_window.set_handler(:delete, method(:delete_spellbook_slot))
    @spellbook_window.set_handler(:select, method(:look_at_spellbook_slot))
    @spellbook_window.help_window = @help_window
  end
  
  def create_level_window
    x = @spellbook_window.width
    y = @help_window.height + @spellbookhelp_window.height
    @spelllevel_window = Window_SpellLevelBar.new(x,y)
    @spelllevel_window.deactivate
    @spelllevel_window.level = @actor.max_spell_level
    @spelllevel_window.help_window = @help_window
  end

  def create_spellbookhelp_window
    x = @spellbook_window.width
    y = @help_window.height
    @spellbookhelp_window =
      Window_SpellbookInfo.new(x, y, 3)
    @spellbookhelp_window.deactivate
    @spellbookhelp_window.category = @category
    @spellbookhelp_window.actor = @actor
    @spellbook_window.info_window = @spellbookhelp_window
  end
  
  # TODO: ensure everything gets disposed.

  
  def create_item_window
    wx = @spellbook_window.width
    wy = @help_window.height + @spellbookhelp_window.height + @spelllevel_window.height
    ww = @spellbookhelp_window.width
    wh = Graphics.height - wy
    @item_window = Window_SpellbookSkillList.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.spellbook_help_window = @spellbookhelp_window
    @item_window.level = 1
    @item_window.refresh
    @item_window.set_handler(:ok,     method(:choose_spell))
    @item_window.set_handler(:cancel, method(:exit_spellbook_slot))
    #@item_window.activate
    @spelllevel_window.skill_window = @item_window
  end
  
  def user
    @actor
  end
  
  def choose_spell
    return unless @actor.has_vancian_casting?
    the_var = $data_skills.index(@item_window.item)
    Sound.play_ok
    
    @actor.prepare_spell_in_slot_at_xy(*@spellbook_window.index_to_spell_tuple, the_var)
    
    @spellbook_window.refresh
    @spellbook_window.activate
    @spelllevel_window.deactivate
    @item_window.deactivate
  end
  
  def delete_spellbook_slot
    return unless @actor.has_vancian_casting?
    level, slot, data = @spellbook_window.current_element
    
    Sound.play_cancel
    @actor.delete_spell_in_slot_at_xy(level, slot, data);
    @spellbook_window.refresh
  end
  def choose_spellbook_slot
    return unless @actor.has_vancian_casting?
    level, slot, data = @spellbook_window.current_element
    
    # SPECIAL HANDLING!
    
    Sound.play_ok
    @spellbook_window.deactivate
    @item_window.current_slot = data
        
    @spelllevel_window.max_level = level + 1;
    @spelllevel_window.activate
    @item_window.reset_cursor
    @item_window.activate
  end
  def look_at_spellbook_slot
    return unless @actor.has_vancian_casting?
    level, slot, data = @spellbook_window.current_element
    
    return unless @item_window
    @item_window.current_slot = data
    @item_window.refresh
    return unless @spelllevel_window
    @spelllevel_window.max_level = level + 1;
  end
  
  
  def exit_spellbook_slot
    Sound.play_cancel
    @spellbook_window.activate
    @item_window.deactivate
    @spelllevel_window.deactivate
  end
  
  def exit_spellbook
    Sound.play_cancel
    VancianCS.lock_in_all_spell_slots
    return_scene
  end
end

class Window_MenuCommand < Window_Command
  def add_main_commands
    add_command(Vocab::item,   :item,   main_commands_enabled)
    add_command(Vocab::skill,  :skill,  main_commands_enabled)
    add_command(VancianCS::MENU_SPELLBOOK_TERM,  :spellbook,  main_commands_enabled)
    add_command(Vocab::equip,  :equip,  main_commands_enabled)
    add_command(Vocab::status, :status, main_commands_enabled)
  end
end

class Scene_Menu < Scene_MenuBase
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:spellbook, method(:command_personal))
    @command_window.set_handler(:talent_tree, method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  
  alias_method  :vancecs_personal_ok, :on_personal_ok
  def on_personal_ok
    vancecs_personal_ok
    if(@command_window.current_symbol == :spellbook)
      SceneManager.call(Scene_Vancian)
    end
  end
end
