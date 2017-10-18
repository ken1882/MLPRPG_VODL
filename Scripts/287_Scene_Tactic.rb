#==============================================================================
# ** Scene_Tactic
#------------------------------------------------------------------------------
#  This class to edit AI's combat tactic logic
#==============================================================================
class Scene_Tactic < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_all_windows
    @command_list.activate
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.background("Canterlot_Room")
  end
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  def create_all_windows
    create_status_window
    create_list_window
    create_action_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_StatusActor.new(0, 0)
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # tag: command (Scene_Tactic
  #--------------------------------------------------------------------------
  def create_list_window
    @command_list = Window_TacticList.new(0, @status_window.height)
    @command_list.actor = @actor
    @command_list.set_handler(:ok,      method(:on_command_ok))
    @command_list.set_handler(:cancel,  method(:return_scene))
    @command_list.set_handler(:pagedown, method(:next_actor))
    @command_list.set_handler(:pageup,   method(:prev_actor))
    @command_list.refresh
  end
  #--------------------------------------------------------------------------
  def create_action_window
     @action_window = Window_TacticAction.new
     @action_window.set_handler(:targeting, method(:on_action_ok))
     @action_window.set_handler(:fighting,  method(:on_action_ok))
     @action_window.set_handler(:self,      method(:on_action_ok))
     @action_window.set_handler(:item,      method(:on_action_ok))
     @action_window.set_handler(:skill,     method(:on_action_ok))
     @action_window.set_handler(:general,   method(:on_action_ok))
     @action_window.set_handler(:cancel,    method(:on_action_cancel))
  end
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_TacticItemList.new(0, 0, 200, 180)
    @item_window.set_handler(:ok, method(:on_item_return))
    @item_window.set_handler(:cancel, method(:on_item_return))
    @action_window.item_window = @item_window
    @item_window.hide
  end
  #--------------------------------------------------------------------------
  def on_command_ok
    @action_window.activate
    rect = @command_list.item_rect(@command_list.index)
    @action_window.x = [(rect.x + rect.width) / 2, Graphics.width - @action_window.width].min
    @action_window.y = [[@command_list.y + rect.y - @command_list.oy + 2, 0].max, Graphics.height - @action_window.height - 2].min
    @action_window.show
    @action_window.select(0)
  end
  #--------------------------------------------------------------------------
  def on_action_ok
    @action_window.unselect
    @action_window.hide
    @item_window.activate
    @item_window.select(0)
  end # last work: tactic processing
  #--------------------------------------------------------------------------
  def on_action_cancel
    if @action_window.symbol.nil?
      @action_window.unselect
      @action_window.hide
      @command_list.activate
    end
  end
  #--------------------------------------------------------------------------
  def on_item_return
    @item_window.unselect
    @item_window.hide
    @command_list.activate
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_list.actor = @actor
    @status_window.actor = @actor
    @status_window.refresh
    @command_list.refresh
    @command_list.activate
    @command_list.select(0)
  end
end
