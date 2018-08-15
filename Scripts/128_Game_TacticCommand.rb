#===============================================================================
# * Game_TacticCommand
#-------------------------------------------------------------------------------
#   Tactic command of AI
#===============================================================================
class Game_TacticCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :battler
  attr_accessor :action
  attr_accessor :condition
  attr_accessor :condition_symbol
  attr_accessor :category
  attr_accessor :enabled
  attr_accessor :args
  attr_accessor :target
  attr_accessor :circled
  attr_accessor :jump_command
  attr_reader   :index_id
  attr_reader   :check_timer
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(battler, args = [])
    @battler   = battler
    @action    = nil
    @args      = args
    @target    = nil
    @condition = ""
    @condition_symbol = nil
    @check_timer = 0
    @enabled   = true
    @jump_command = nil
    @circled   = false
    @index_id  = 0
  end
  #--------------------------------------------------------------------------
  def index_id=(id)
    @index_id = id
  end
  #--------------------------------------------------------------------------
  def condition_legel?
    return false if condition.include?('$')
    return false if condition.each_char.any?{|ch| 'A' <= ch && ch <= 'Z'}
    spell_ok = true
    begin
      eval(@condition)
    rescue Exception => err
      spell_ok = false
      return err
    end
    return true
  end
  #--------------------------------------------------------------------------
  def check_condition(forced = false)
    return unless (@enabled && @check_timer == 0) || forced
    return false unless @battler.cooldown_ready?(@action.item)
    #return eval(@condition) if condition_symbol == :code
    @target = nil
    case @category
    when :targeting
      @target = Tactic_Config::Enemy.start_check(@battler, @condition_symbol, @args)
      return @target ? true : false
    when :fighting
      return false unless @battler.current_target
      if @battler.current_target.dead?
        @battler.process_target_dead
        return false
      end
      return Tactic_Config::Target.start_check(@battler, @condition_symbol, @args)
    when :self
      return Tactic_Config::Players.start_check(@battler, @condition_symbol, @args)
    end
  end
  #--------------------------------------------------------------------------
  def get_target
    case @category
    when :targeting
      return @target
    when :fighting
      return @battler.current_target
    when :self
      return @battler
    end
  end
  #--------------------------------------------------------------------------
  def valid?
    return false if @circled
    return false if !@condition_symbol
    return false if @action.item == :jump_to && !@jump_command
    return false if !@action || !@action.valid?
    return true
  end
  #--------------------------------------------------------------------------
  def disabled?
    !@enabled
  end
  #--------------------------------------------------------------------------
  def enabled?
    @enabled
  end
  #--------------------------------------------------------------------------
end
