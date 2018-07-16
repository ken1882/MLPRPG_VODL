#==============================================================================
# ** Window_LevelUpIndex
#------------------------------------------------------------------------------
#  Index item for level up feats selection or skill tree index
#==============================================================================
# tag: level up
class Window_LevelUpIndex < Window_MultiCommand
  include DND::Utility
  #--------------------------------------------------------------------------
  attr_reader :actor
  attr_reader :category
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, _actor)
    super(x, y, width, height)
    actor = _actor
  end
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Category
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  def make_item_list
    list_for_levelup if @category == :levelup
  end
  #--------------------------------------------------------------------------
  def list_for_levelup
    add_command(name: @actor.class.name, symbol: :levelup_main, 
                help: Helps[:level_up_main])
    set_handler(:levelup_main, method(:levelup_main))
    
    if @actor.dualclass_id == 0
      add_command(name: DualClass, symbol: :dualclass, child: :dualclass_list,
                help: Helps[:dualclass])
                
      make_dualclass_list 
    else
      add_command(name: @actor.class.name, symbol: :levelup_dual, 
                help: Helps[:level_up_dual])
      set_handler(:levelup_dual, method(:levelup_dual))
    end
  end
  #--------------------------------------------------------------------------
  def make_dualclass_list
    cat = :dualclass_list
    class_id = DND::ClassID::PrimaryPathes.collect{|c| c.first}
    @dualclass_symbols = []
    
    class_id.each do |id|
      nam = $data_classes[id].name
      sym = nam.downcase.to_sym
      hel = $data_classes[id].description
      hel = hel ? hel : nam
      ena = class_requirement_meet?(id)
      add_command(name: nam, symbol: sym, help: hel, category: cat, ext: id, enabled: ena)
      set_handler(sym, mehtod(:set_dualclass))
      @dualclass_symbols.push(sym)
    end
  end
  #--------------------------------------------------------------------------
  def levelup_main
    return unless @actor
    @actor.level_up_class(@actor.class_id)
    Sound.level_up
  end
  #--------------------------------------------------------------------------
  def levelup_dual
    return unless @actor
    @actor.level_up_class(@actor.dualclass_id)
    Sound.level_up
  end
  #--------------------------------------------------------------------------
  def set_dualclass(id)
    return unless @actor
    @actor.setup_dualclass(id)
    Sound.level_up
  end
  #--------------------------------------------------------------------------
  def class_requirement_meet?(id)
    return $data_classes[id].class_requirement_meet?(@actor)
  end
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    super unless current_category == :dualclass_list
    super unless @dualclass_symbols.include?(symbol)
    class_id = @list[current_category].find{|c| c[symbol] == :symbol}[:ext] rescue nil
    unless (class_id || 0).to_bool
      raise ArgumentError, "cannot find class id for symbol: #{symbol}"
    end
    @handler[symbol].call(class_id)
  end # last work: level up scene
  #--------------------------------------------------------------------------
end
