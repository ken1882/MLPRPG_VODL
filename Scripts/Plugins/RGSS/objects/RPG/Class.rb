#==========================================================================
# ■ RPG::Class
#==========================================================================
class RPG::Class < RPG::BaseItem
  #------------------------------------------------------------------------
  # * instance variables
  #------------------------------------------------------------------------
  attr_reader :parent_class
  attr_reader :requirement
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    super
    apply_default_attributes
    dnd_loading = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Leveling::LoadStart; dnd_loading = true;
      when DND::REGEX::Leveling::LoadEnd;   dnd_loading = false;
      end
      load_dnd_attribute(line) if dnd_loading
    end
  end
  #--------------------------------------------------------------------------
  def load_dnd_attribute(line)
    case line
    when DND::REGEX::Leveling::ClassParent;  @parent_class    = $1.to_i;
    when DND::REGEX::Leveling::HP;           @param_adjust[0] = $1.to_i;
    when DND::REGEX::Leveling::EP;           @param_adjust[1] = $1.to_i;
    when DND::REGEX::Leveling::Strength;     @param_adjust[2] = $1.to_i;
    when DND::REGEX::Leveling::Constitution; @param_adjust[3] = $1.to_i;
    when DND::REGEX::Leveling::Intelligence; @param_adjust[4] = $1.to_i;
    when DND::REGEX::Leveling::Wisdom;       @param_adjust[5] = $1.to_i;
    when DND::REGEX::Leveling::Dexterity;    @param_adjust[6] = $1.to_i;
    when DND::REGEX::Leveling::Charisma;     @param_adjust[7] = $1.to_i;
    when DND::REGEX::Leveling::Requirement;  load_class_reqs($1);
    end
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @parent_class = 0
    @param_adjust = Array.new(8, 0)
    @requirement  = nil
  end
  #------------------------------------------------------------------------
  def param(id)
    re  = (@param_adjust[id] || 0)
    re += $data_classes[@parant_class].param(id) if @parent_class > 0
    return re
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    return (DND::EXP_FOR_LEVEL[level] * 1000).to_i
  end
  #--------------------------------------------------------------------------
  # * Load class requirements, safer mehtod should turn infix to postfix
  #--------------------------------------------------------------------------
  def load_class_reqs(str)
    str      = str.downcase
    brackets = [0,0]
    str.each_char do |ch|
      case ch
      when '['; brackets[0]   += 1;
      when ']'; brackets[1]   += 1;
      when '('; brackets[0]   += 1;
      when ')'; brackets[1]   += 1;
      end
      
      if brackets[0] < brackets[1]
        msgbox "An critical SyntaxError detected in your database:"
        msg = "Brackets number unequal in:\n" + sprintf("(%03d)%s: %s", id, name,str)
        raise SyntaxError, msg
      end
    end
    @requirement = str.tr('[]','')
  end
  #--------------------------------------------------------------------------
  # * Check score ability whether meet the requirement
  #--------------------------------------------------------------------------
  def class_requirement_meet?(actor)
    req = @requirement.dup
    ['str', 'con', 'dex', 'int', 'wis', 'cha'].each do |score|
      req.gsub!(score, actor.param(get_param_id(score)).to_s)
    end
    eval(req)
  end
  #--------------------------------------------------------------------------
end