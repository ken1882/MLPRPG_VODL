#===============================================================================
# * Game_TacticCommand
#-------------------------------------------------------------------------------
#   Tactic command of AI
#===============================================================================
class Game_TacticCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actor
  attr_accessor :action
  attr_accessor :condition
  attr_accessor :condition_symbol
  attr_accessor :category
  attr_accessor :enabled
  attr_accessor :args
  attr_accessor :target
  attr_reader   :check_timer
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor, args = [])
    @actor     = actor
    @action    = nil
    @args      = args
    @target    = nil
    @condition = ""
    @condition_symbol = nil
    @check_timer = 0
    @enabled   = true
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
    return false unless @actor.cooldown_ready?(@action.item)
    #return eval(@condition) if condition_symbol == :code
    case @category
    when :targeting
      @target = Tactic_Config::Enemy.start_check(@actor, condition_symbol, args)
      return @target ? true : false
    when :fighting
      return false unless @actor.current_target
      if @actor.current_target.dead?
        @actor.process_target_dead
        return false
      end
      return Tactic_Config::Target.start_check(@actor, condition_symbol, args)
    when :self
      return Tactic_Config::Players.start_check(@actor, condition_symbol, args)
    end
  end
  #--------------------------------------------------------------------------
  def get_target
    case @category
    when :targeting
      return @target
    when :fighting
      return @actor.current_target
    when :self
      return @actor
    end
  end
  #--------------------------------------------------------------------------
  def valid?
    return false if !condition_symbol
    return false if !action || !action.valid?
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
