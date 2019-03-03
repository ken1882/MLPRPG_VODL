#===============================================================================
# * RPG::Skill
#===============================================================================
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  attr_reader :selectable_skill
  #--------------------------------------------------------------------------
  def load_notetags_dndattrs
    super
    @selectable_skill = nil
    on_leveling_load = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when DND::REGEX::Leveling::LevelingStart
        @property |= PONY::Bitset[5]
        on_leveling_load = true
      when DND::REGEX::Leveling::LevelingEnd
        on_leveling_load = false
      else
        load_leveling_property(line) if on_leveling_load
      end
    end
  end
  #--------------------------------------------------------------------------
  def load_leveling_property(line)
    case line
    when DND::REGEX::Leveling::SelectSkill
      sel = Struct.new(:number, :index).new(0, [])
      sel.number = $2.to_i
      $1.split(',').each{|sid| sel.index.push(sid.to_i)}
      @selectable_skill = sel
    end
  end
  #--------------------------------------------------------------------------
  def is_skill?
    @stype_id == DND::SKILL_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_spell?
    @stype_id == DND::SPELL_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_vancian?
    @stype_id == DND::VANCIAN_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def is_passive?
    @stype_id == DND::PASSIVE_STYPE_ID
  end
  #--------------------------------------------------------------------------
  def stype_symbol
    case @stype_id
    when DND::SKILL_STYPE_ID;   return :skill;
    when DND::SPELL_STYPE_ID;   return :spell;
    when DND::VANCIAN_STYPE_ID; return :vancian;
    when DND::PASSIVE_STYPE_ID; return :passive;
    end
  end
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  #---------------------------------------------------------------------------  
  def load_help_information
    path = Vocab.GetDictPath(:skill)
    DataManager.ensure_file_exist(path)
    filename = path + self.id_for_filename
    filename = Dir.glob(filename + '*').at(0)
    info = ""
    return self.description unless (filename && File.exist?(filename))
    File.open(filename, 'r') do |file|
      while(line = file.gets)
        info += line
      end
    end
    return info.size >= description.size ? info : description
  end
  #---------------------------------------------------------------------------
end