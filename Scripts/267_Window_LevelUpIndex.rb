#==============================================================================
# ** Window_LevelUpIndex
#------------------------------------------------------------------------------
#  Index item for level up feats selection or skill tree index
#==============================================================================
# tag: level up
class Window_LevelUpIndex < Window_MultiCommand
  include Vocab::Leveling
  include DND::Utility
  #--------------------------------------------------------------------------
  attr_reader :actor
  attr_reader :category
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, _actor)
    @width, @height = width, height
    @actor = _actor
    super(x, y)
    self.actor = _actor
    create_confirm_window
    unselect
    deactivate
  end
  #--------------------------------------------------------------------------
  def create_confirm_window
    @overlay_window = Window_Confirm.new(160, 180)
  end
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  def window_width
    @width
  end
  #--------------------------------------------------------------------------
  def window_height
    @height
  end
  #--------------------------------------------------------------------------
  def contents_height
    line_height * DND::ClassID::PrimaryPathes.size
  end
  #--------------------------------------------------------------------------
  def entry_categories
    super + [:levelup]
  end
  #--------------------------------------------------------------------------
  # * Set Category
  #--------------------------------------------------------------------------
  def set_category(cat)
    self.oy = 0
    super
  end
  #--------------------------------------------------------------------------
  def make_command_list
    list_for_levelup
  end
  #--------------------------------------------------------------------------
  def list_for_levelup
    cat = :levelup
    add_command(name: @actor.class.name, symbol: :levelup_main, category: cat,
                help: Helps[:level_up_main])
    
    if @actor.dualclass_id == 0
      add_command(name: DualClass, symbol: :dualclass, child: :dualclass_list,
                help: Helps[:set_dualclass], category: cat)
                
      make_dualclass_list 
    else
      add_command(name: @actor.class.name, symbol: :levelup_dual, 
                help: Helps[:level_up_dual], category: cat)
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
      if hel && @help_window
        hel = FileManager.textwrap(hel, @help_window.width - 32)
      else
        hel = $data_classes[id].requirement
      end
      ena = class_requirement_meet?(id)
      
      if DND::ClassID::Wizard.include?(id)
        ena = false if DND::NoWizardry.include?(@race_id)
      end
      
      ena = false if id == @actor.class_id
      ena = false if id == @actor.class.parent_class if @actor.class
      
      add_command(name: nam, symbol: sym, help: hel, category: cat, ext: id, enabled: ena)
      @dualclass_symbols.push(sym)
    end
  end
  #--------------------------------------------------------------------------
  def make_feat_commands(feat_skillid)
    leveling_skill = $data_skills[feat_skillid]
    cat = :select_feat
    @feat_select_number   = leveling_skill.selectable_skill.number
    @selected_feat_symbol = []
    leveling_skill.selectable_skill.index.each do |sid|
      skill = $data_skills[sid]
      add_command(category: cat, name: skill.name, symbol: skill.name.to_sym,
                  help: skill.description, ext: skill.id)
                  
      set_handler(skill.name.to_sym, method(:select_new_skill))
    end
    
  end
  #--------------------------------------------------------------------------
  def set_default_handlers
    set_handler(:levelup_main, method(:levelup_main))
    set_handler(:levelup_dual, method(:levelup_dual))
    @dualclass_symbols.each do |sym|
      set_handler(sym, method(:set_dualclass))
    end
  end
  #--------------------------------------------------------------------------
  def levelup_main
    return unless @actor
    @actor.level_up_class(@actor.class_id)
    process_levelup
  end
  #--------------------------------------------------------------------------
  def levelup_dual
    return unless @actor
    @actor.level_up_class(@actor.dualclass_id)
    process_levelup
  end
  #--------------------------------------------------------------------------
  def set_dualclass
    return unless @actor
    class_id = current_data[:ext]
    unless (class_id || 0).to_bool
      raise "cannot find class id for symbol: #{current_data[:symbol]}"
    end
    @actor.change_dualclass(class_id, false)
    process_levelup
  end
  #--------------------------------------------------------------------------
  def process_levelup
    @actor.level_up
    Sound.level_up
    call_handler(:on_levelup_finish)
  end
  #--------------------------------------------------------------------------
  def cancel_enabled?
    return false if current_category == :select_feat
    return super
  end
  #--------------------------------------------------------------------------
  def class_requirement_meet?(id)
    return $data_classes[id].class_requirement_meet?(@actor)
  end
  #--------------------------------------------------------------------------
  def select_new_skill
    skill_id = current_data[:ext]
    @actor.learn_skill(skill_id)
    @feat_select_number -= 1
    if @feat_select_number > 0
      @list[current_category].delete(current_data)
      refresh_item
    else
      call_handler(:on_feat_ok)
    end
  end
  #--------------------------------------------------------------------------
  def call_ok_handler
    case current_symbol
    when :set_dualclass
      info = sprintf(Confirm_Dualclass, current_data[:name])
      raise_overlay(info, :call_handler, current_symbol)
    when :select
      info = sprintf(Confirm_LearnSkill, current_data[:name])
      raise_overlay(info, :call_handler, current_symbol)
    else
      super
    end
  end
  #--------------------------------------------------------------------------
end
