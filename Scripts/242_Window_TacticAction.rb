#==============================================================================
# ** Window_TacticAction
#------------------------------------------------------------------------------
#  Displaying the actions tactic commands when selected
#==============================================================================
# tag: command (Tactic Action
class Window_TacticAction < Window_Command
  #--------------------------------------------------------------------------
  attr_accessor :command
  attr_accessor :actor
  attr_reader   :symbol
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0)
    super
    self.windowskin = Cache.system(WindowSkin::ItemAction)
    make_default_handler
    @actor    = nil
    @command  = nil
    unselect
    hide
  end
  #--------------------------------------------------------------------------
  def update
    super 
    if @item_window && !@ok_called
      @item_window.category = current_symbol
      @item_window.command  = @command
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Sound.play_ok 
      Input.update
      deactivate unless @symbol.nil?
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Cancel Button Is Pressed
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    Input.update
    deactivate if @symbol.nil?
    @symbol = nil
    call_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  # tag: translate
  #--------------------------------------------------------------------------
  def make_command_list
    if @symbol == :condition
      add_command('Enemy targeting', :targeting)
      add_command('Target fighting', :fighting)
      add_command('Self and party', :self)
    elsif @symbol == :action
      add_command('Items', :item)
      add_command('Skills', :skill)
      add_command('General', :general)
    else
      add_command('Edit condition', :call_condition)
      add_command('Edit Action', :call_action)
      add_command('Delete', :call_delete)
    end
  end
  #--------------------------------------------------------------------------
  def make_default_handler
    set_handler(:call_condition, method(:on_condition_ok))
    set_handler(:call_action,    method(:on_action_ok))
  end
  #--------------------------------------------------------------------------
  def on_condition_ok
    @symbol = :condition
    refresh
  end
  #--------------------------------------------------------------------------
  def on_action_ok
    @symbol = :action
    refresh
  end
  #--------------------------------------------------------------------------
  def activate(command = nil, actor = nil)
    @command = command
    @actor   = actor
    @symbol  = nil
    @ok_called = false
    super()
    self.opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  def deactivate
    super
    @ok_called = true
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  #--------------------------------------------------------------------------
end
