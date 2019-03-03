#==========================================================================
# ■ RPG::Actor
#==========================================================================
class RPG::Actor < RPG::BaseItem
  #------------------------------------------------------------------------
  # * instance variables
  #------------------------------------------------------------------------
  #tag: charparam
  #tag: actor
  attr_reader :death_graphic        # Graphic filename when K.O
  attr_reader :death_index          # Graphic index
  attr_reader :death_pattern        # Pattern
  attr_reader :death_direction      # Direction
  attr_reader :death_sound
  attr_reader :casting_graphic
  attr_reader :casting_index
  attr_reader :casting_pattern
  attr_reader :icon_index
  attr_reader :parent_class
  attr_reader :dualclass_id, :race_id, :subrace_id
  attr_reader :class_levelcap
  #--------------------------------------------------------------------------
  # * Attributes setup
  #--------------------------------------------------------------------------
  def load_character_attributes
    super
    apply_default_attributes
    dnd_loading = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Character::KOGraphic;   @death_graphic   = $1
      when DND::REGEX::Character::KOIndex;     @death_index     = $1.to_i
      when DND::REGEX::Character::KOPattern;   @death_pattern   = $1.to_i
      when DND::REGEX::Character::KODirection; @death_direction = $1.to_i
      when DND::REGEX::Character::KODirection; @death_sound     = $1.to_i
      when DND::REGEX::Character::CastGraphic; @casting_graphic = $1.to_i
      when DND::REGEX::Character::CastIndex;   @casting_index   = $1.to_i
      when DND::REGEX::Character::CastPattern; @casting_pattern = $1.to_i
      when DND::REGEX::Character::IconIndex;   @icon_index      = $1.to_i
      when DND::REGEX::Character::CastingAnimation; @casting_animation = $1.to_i
      when DND::REGEX::Leveling::LoadStart; dnd_loading = true;
      when DND::REGEX::Leveling::LoadEnd;   dnd_loading = false;
      end
      load_dnd_attribute(line) if dnd_loading
    end
  end
  #--------------------------------------------------------------------------
  def load_dnd_attribute(line)
    case line
    when DND::REGEX::Leveling::Race;      @race_id         = $1.to_i
    when DND::REGEX::Leveling::Subrace;   @subrace_id      = $1.to_i
    when DND::REGEX::Leveling::Class
      # Primary Class selection is loaded from default RM database editor
    when DND::REGEX::Leveling::DualClass
      info          = $1.split(',')
      @dualclass_id = (info.first.to_i || 0)
      @class_levelcap[@dualclass_id][0] = [info.last.to_i, 1].max
    when DND::REGEX::Leveling::HP;           @param_adjust[0]   = $1.to_i
    when DND::REGEX::Leveling::EP;           @param_adjust[1]   = $1.to_i
    when DND::REGEX::Leveling::Strength;     @param_adjust[2]   = $1.to_i
    when DND::REGEX::Leveling::Constitution; @param_adjust[3]   = $1.to_i
    when DND::REGEX::Leveling::Intelligence; @param_adjust[4]   = $1.to_i
    when DND::REGEX::Leveling::Wisdom;       @param_adjust[5]   = $1.to_i
    when DND::REGEX::Leveling::Dexterity;    @param_adjust[6]   = $1.to_i
    when DND::REGEX::Leveling::Charisma;     @param_adjust[7]   = $1.to_i
    end # case
  end
  #--------------------------------------------------------------------------
  def apply_default_attributes
    @death_graphic      = DND::BattlerSetting::KOGraphic
    @death_index        = DND::BattlerSetting::KOIndex
    @death_pattern      = DND::BattlerSetting::KOPattern
    @death_direction    = DND::BattlerSetting::KODirection
    @casting_animation  = DND::BattlerSetting::CastingAnimation
    @race_id            = DND::BattlerSetting::DefaultRaceID
    
    @param_adjust = Array.new(8, 0)
    @subrace_id   = @dualclass_id = 0
    
    # Initial element for classes' init level and level cap
    init_lvl_ele = [0, DND::BattlerSetting::LevelCap]
    @class_levelcap  = Array.new($data_classes.size, init_lvl_ele)
    @class_levelcap[@class_id][0] = @initial_level
  end
  #--------------------------------------------------------------------------
end