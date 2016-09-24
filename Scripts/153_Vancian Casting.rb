#
# Vancian Casting System 
#  (v0.1.0, 2015-10-14)
#   mmys
#
# END USER NOTES:
# Q. What is this?
# A. This script adds a Vancian spellcasting system to RMVXA. You might be
#    familiar with Vancian casting from the Dungeons & Dragons game systems.
#    If you're not, then here's a TV Tropes link:
#       http://tvtropes.org/pmwiki/pmwiki.php/Main/VancianMagic
#    Either way, that's what this system tries to add.
#
# Q. How do I use it?
# A. The script itself requires a bit of set up. There's basically four steps
#    to get this up and running:
#     1. Set up casting progressions.
#     2. Tie classes to casting progressions in the database.
#     3. Add casting levels to spells.
#     4. Tweak config settings to taste.
#
# Q. Can I use this in my personal project/commercial project/toaster oven?
# A. You may use this script in any project, commercial or otherwise, for free,
#    without royalties, etc., etc., etc., so long as you provide credits
#    somewhere. Also, if it's a commercial game, I'd appreciate a free copy
#    when you're done, but that's up to you.
#
#    You may not redistribute this without my permission.
#
# Q. I found a crippling bug, what do?
# A. Uh, message me, I guess? The more [relevant] detail, the better.
#
#
# DEVELOPER NOTES:
# These notes are of particular interest to you if you're handy with RGSS,
# and want to mess around with the inner workings of the script.
# Q. I'd like to add some functionality...
# A. It'd be strongly preferred if it was separate. Note that this script is
#    very early in its lifespan, and there's still a fair bit of functionality
#    I've been wanting to add; there's a very good chance there will be a lot
#    of API-breaking changes in the near future.
#
module VancianCS
  extend self
  
################################################################################
#  END-USER CONFIG STARTS HERE
#  Feel free to edit!
################################################################################
  # the name of the menu command
  MENU_SPELLBOOK_TERM = "Spellbook"
  
  # how spell preparation and erasing works. one of the following symbols:
  #  :readied_slots
  #    When you rest, all spells are un-expended. You can fill slots, and
  #    empty slots, and have them ready to cast--either until you exit
  #    the spellbook for the first time, OR you enter your first combat.
  #  :by_the_book
  #    When you rest, all spells are un-expended. Any time you fill a slot,
  #    it is already expended (this apes how it works in the d20 System.)
  SPELL_PREPARATION_STYLE = :by_the_book
  
  # translates terms on the left (tags used internally, pretty much), to
  #  what names you'd like them to show up as in-game.
  # This is still a work on progress, and may be overhauled in the future.
  TAG_TERMS = {
    "arcane" => "Arcane",
    "evocation" => "Evocation",
    "conjuration" => "Conjuration",
    "necromancy" => "Necromancy",
    "transmutation" => "Transmutation",
    "abjuration" => "Abjuration",
    "enchantment" => "Enchantment",
    "illusion" => "Illusion",
    "alteration" => "Alteration",
    "divination" => "Divination"
    
  }
  
  # Casting progression initialization--this is the good stuff!
  # See the manual (or read the code) for more details about this.
  def init
    push_class("Witch", "arcane", 9){
      # Specialized slots; just a demonstration...
      add_progression(
        0  => [1],
        1  => [1],
        3  => [1,1],
        5  => [1,1,1],
        7  => [1,1,1,1],
        10 => [1,1,1,1,1],
        13 => [1,1,1,1,1,1],
        16 => [1,1,1,1,1,1,1],
        18 => [1,1,1,1,1,1,1,1],
        20 => [1,1,1,1,1,1,1,1,1],
      ).all_of {
        #tag "evocation"
        #day_of_the_week "Wednesday"
        tag ""
        day_of_the_week ""
      }
      
      add_progression(
        0 => [0],
        1 => [1],
        2 => [2],
        3 => [2,1],
        4 => [3,2],
        5 => [4,2,1],
        6 => [4,2,2],
        7 => [4,3,2,1],
        8 => [4,3,2,2],
        9 => [4,3,3,2,1],
        10 => [4,3,3,2,2],
        11 => [4,4,4,2,2],
        12 => [4,4,4,3,3],
        13 => [4,4,4,4,3,1],
        15 => [5,5,5,5,4,2],
        16 => [5,5,5,5,5,3,1],
        17 => [5,5,5,5,5,3,2],
        18 => [5,5,5,5,5,3,2,1],
        19 => [5,5,5,5,5,3,3,1],
        20 => [5,5,5,5,5,3,3,1,1],
        21 => [5,5,5,5,5,4,3,2,1],
        22 => [5,5,5,5,5,4,4,2,1],
        23 => [5,5,5,5,5,5,4,2,1],
        24 => [5,5,5,5,5,5,5,3,1],
        25 => [5,5,5,5,5,5,5,3,2],
        26 => [5,5,5,5,5,5,5,3,3],
        27 => [5,5,5,5,5,5,5,4,3],
        28 => [5,5,5,5,5,5,5,4,4],
        29 => [5,5,5,5,5,5,5,5,4],
        30 => [5,5,5,5,5,5,5,5,5],
      )
      # You can add any number of progressions as desired.
    };
    
    # You can also specify a progression by constructing an array, with one
    #  entry for each level. If you don't want progression to change for that
    #  level, put nil in (incidentally, this is how it's stored internally.)
    # For instance, the above progression is equivalent to the below:
    #[
    #  [3],nil,nil,nil,        # 1
    #  [3,1],nil,nil,nil,      # 5
    #  [4,2,1],nil,nil,nil,    # 9   
    #  [4,2,2,1],nil,nil,nil,  # 13
    #  [5,3,2,2,1],nil,nil,nil,# 17
    #  [5,3,3,2,2],nil,nil,nil,# 21
    #  [6,4,3,3,2],nil,nil,nil,# 25
    #  [6,4,4,3,3],nil,nil,nil,# 29
    #  [6,5,4,4,3],nil,nil,nil,# 33
    #  [6,5,5,4,4],nil,nil,nil,# 37
    #  [6,6,5,5,4],nil,nil,nil,# 41
    #  [6,6,6,5,5]             # 45
    #]);
    
    # replace this hard-coding later with a sweep
  end
  
################################################################################
#  END-USER CONFIG ENDS HERE
#
#  DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING!
################################################################################
  
  @spell_levels
  @last_class
  @class_sets = []
  
  def push_class(name, category, levels, &block)
    @class_sets.push(VancianProgression.new(name, levels, category, &block))
    @last_class = @class_sets.last
  end
  
  def get_class(name)
    @class_sets.select{|x| x.name == name}.first
  end
  
  def append_vocab_term(old, new)
    TAG_TERMS[old] = new
  end
  
  def get_synonym(old)
    return TAG_TERMS[old] if TAG_TERMS.has_key?(old)
    return old
  end
  
  def verify_config
    spell_preps = [:readied_slots, :by_the_book];
    raise "Your SPELL_PREPARATION_STYLE constant is invalid!" \
          unless spell_preps.include?(SPELL_PREPARATION_STYLE)
  end
#------------------------------------------------------------------------------
#| Extension of VancianCS : Module
#| * Adds additional global-level functions for the system as a whole.
#------------------------------------------------------------------------------
  
  # restore_all_spell_slots() -> nil
  #
  # Un-expends, and allows replacement of all memorized spell slots
  # for all party members.
  def restore_all_spell_slots
    $game_party.all_members.each do |actor|
      actor.restore_spells
    end
  end
  
  # lock_in_all_spell_slots() -> nil
  #
  # Disallows replacement of all spell slots. Usually called after exiting
  # the spellbook, or entering a combat (to prevent spell switching in
  # certain modes.)
  def lock_in_all_spell_slots
    $game_party.all_members.each do |actor|
      actor.lock_in_spells
    end
  end
end
#------------------------------------------------------------------------------
#| VancianProgression : Class
#| * Handles casting progressions; the number and nature of spell slots based
#|   on level.
#------------------------------------------------------------------------------
class VancianProgression
  # add_progression(Array or Hash, [ &block) -> VancianProgressionHash
  #
  # Adds a new spell slot progression to the casting progression. 
  # The block is for defining restrictions.
  # This doesn't return self, so it's recommended you not try to construct
  #  pipelines with it.
  def add_progression(input={}, &block)
    table = progression_to_table(input, @max_level);
    
    progression_hash = VancianProgressionHash.new
    progression_hash[:table] = table
    progression_hash[:restrictions] = \
      VancianSlotRestrictions.process(&block) if block_given?
    
    @table_sets.push(progression_hash);
    return progression_hash;
  end
  
  # at_level(Fixnum) -> spell_slots (see VancianCS for definition)
  #
  # Generates all spell slots that would be available to this progression,
  #  at level x.
  def at_level(level)
    level -= 1
    @table_sets.map {|prog_set|
      set = prog_set[:table];
      restrictions = prog_set[:restrictions]
      x = level;
      next [set[x], restrictions] if set[x].is_a?(Array)
      
      value = nil; # returns don't work properly in blocks, and next acts 
                   # screw with loops (obviously)
      x = set.length - 1 if x > set.length - 1
      x.downto(0) do |i|
        value = [set[i], restrictions] if set[i].is_a?(Array)
        break if value
      end
      next value if value
      raise "ERROR: There was no valid spell level set below level #{x} for #{set}."
    }.map {|map_set|
      set, restrictions = map_set
      
      Array.new(@max_level) {|spell_level|
        Array.new(set[spell_level] || 0) {|i|
          {:spell_id => nil, 
           :restrictions => restrictions,
           :expended => false, 
           :replaceable => false,
           :category => self.category}
        }
      }
    }.transpose.map{|level| 
      level.reduce(:+)
    }.select {|level|
      !level.empty?
    }# why is ruby so amazing and so horrible at the same time
  end
  
  # progression_to_table(Array or Hash, Fixnum) -> Array
  #
  # Takes either an array or hash denoting a spell slot progression, and
  #  returns an array in a standard format (an element is an array if slots
  #  change at a level given by the index, nil otherwise.)
  def progression_to_table(table, max_level)
    if table.is_a?(Hash)
      prog_table = Array.new(max_level);
      table.each_pair do |k, v|
        prog_table[k] = v;
      end
    elsif table.is_a?(Array)
      prog_table = table;
    else
      raise "Invalid progression table input; received #{table.class.name}";
    end
    return prog_table
  end
  
  # Getters; probably doesn't need any documentation...
  attr_reader :name
  attr_reader :max_level
  def category
    @synonym || @name
  end
  
  ##############################################################################
  
  attr_reader :name
  def initialize(name, levels, synonym = nil, &block)
    @name = name
    @synonym = synonym;
    @max_level = levels
    
    @table_sets = [];
    
    self.instance_eval(&block) if block_given?
  end
end
#------------------------------------------------------------------------------
#| VancianProgressionHash : Class
#| * Helper class for VancianProgression. Allows methods to be called on
#|   progressions.
#------------------------------------------------------------------------------
class VancianProgressionHash < Hash
  # any_of(&block) -> nil
  #
  # Takes a block to add restrictions based on. All conditions in the block
  #  are OR conditions--that is to say, it's satisfied if any are.
  def any_of(&block)
    self[:restrictions] = VancianSlotRestrictions.process_or(&block)
  end
  
  # all_of(&block) -> nil
  #
  # Takes a block to add restrictions based on. All conditions in the block
  #  are AND conditions--that is to say, it's only satisfied if all are.
  def all_of(&block)
    self[:restrictions] = VancianSlotRestrictions.process(&block)
  end
end
################################################################################
#                        CORE FUNCTIONALITY CODE                               #
#                                                                              #
#------------------------------------------------------------------------------
#| VancianCasting : Mixin
#| * All functions needed for one class to gain Vancian Casting ability. All
#|   functionality was originally placed in a mixin to allow easy creation
#|   of a minimal casting class (for the purposes of unit testing.)
#------------------------------------------------------------------------------
module VancianCasting
  # Handy accessor functions
  
  # max_spell_level() -> Fixnum or nil
  #
  # Returns the highest spell level supported by the source progression.
  # DOES NOT return the highest level spell capable of being cast.
  def max_spell_level
    return @source.max_level if @source
    nil
  end
  
  # has_vancian_casting?() -> VancianProgression
  #
  # Returns the source VancianProgression. Since Ruby is truthy, you
  # can evaluate it like a boolean without any real issue.
  def has_vancian_casting?
    return @source# == nil
  end
  
  # casting_category() -> String or nil
  #
  # Returns the source's casting category. This is either its name, or
  # its specific category (or it's nil, in case there's no source.)
  def casting_category
    return nil unless has_vancian_casting?
    return @source.category
  end
  
  # spell_slots are:
  # an Array of,   Arrays of,       Hashes with keys
  #               ^ one per level    ^ one per spell
  # The hashes have keys you can see below.
  
  @basic_spell_slots = []; # class-based progression
  # These still need to be implemented--and this might require some very
  #  serious redesign, since these are by-character, not by-progression.
  #@bonus_spell_slots = []; # from a high casting stat (for example)
  #@extra_spell_slots = []; # from one-shot deals
  def available_spell_slots
    @basic_spell_slots
  end
  
  # build_spell_slots() -> nil
  #
  # Builds a set of all spell slots from source.
  def rebuild_spell_slots(level)
    return unless @source
    @active_spell_slots = @source.at_level(level);
    # Additional restricted slots may need to be appended off of an
    #  Array.each (or barring that, I add some default handling for
    #  basic spell slots, and staple them on--either way, think
    #  of it later)
  end
  
  @active_spell_slots = [];
  attr_reader :active_spell_slots
  
  # Updates spell slots without destroying them.
  def update_spell_slots(level)
    return unless @source
    
    current_spells = active_spell_slots;
    rebuild_spell_slots(level)
    
    # At the moment, this presrves order but not spacing
    # Directly moving over based on coordinates or what-not may not work,
    #  since we're not guaranteed order of conditional spell slots.
    current_spells.each_with_index do |level|
      level.each_with_index do |slot|
        next unless slot[:spell_id]
        prepare_spell(slot[:spell_id]);
      end
    end
    # TODO: Faster implementation of this
  end
  
  # Un-expends all spells, and lets them be re-prepareable on.
  def restore_spells
    return unless @source
    active_spell_slots.each do |level|
      level.each do |slot|
        slot[:expended] = false;
        # replaceable has no meaning in by the book mode; just never enable
        #  it, and stop drawing those silly rectangles
        if VancianCS::SPELL_PREPARATION_STYLE != :by_the_book
          slot[:replaceable] = true;
        end
      end
    end
  end
  
  def lock_in_spells
    return unless @source
    active_spell_slots.each do |level|
      level.each do |slot|
        slot[:replaceable] = false;
      end
    end
  end
  
################################################################################
  
  def initialize_vancian_casting(source = nil, level = 1)
    @source = source;
    rebuild_spell_slots(level)
  end
  
################################################################################
  
  def get_spell_level_row(level)
    #return nil unless active_spell_slots
    #return nil unless level
    return nil if level != @row
    unless(active_spell_slots.length == level)
      return active_spell_slots[level]
    end
    return nil;
  end
  
  def get_spell_slot(level, row)
    unless(active_spell_slots.length < level)
      unless(active_spell_slots[level].length < row)
        return active_spell_slots[level][row]
      end
    end
    return nil;
  end
  
  def get_row_by_spell_id(spell_id)
    spell = $data_skills[spell_id]
    row = get_spell_level_row(spell.spell_level(@source.category) - 1);
    return row;
  end
  
################################################################################
  # TODO: Split out to a backend function, and add error checking to these
  
  # Attempts to prepare a spell given an id.
  def prepare_spell(spell_id)
    row = get_row_by_spell_id(spell_id);
    return false unless row;
    
    ideal_slots = [];
    suboptimal_slots = [];
    row.each_with_index do |slot, i|
      next if slot[:spell_id] && !slot[:replaceable]
      next unless is_slot_available_for_spell?(slot, slot[:spell_id],row);
      if slot[:replaceable]
        suboptimal_slots.push(slot);
      else
        ideal_slots.push(slot);
      end
    end
    
    return true if prepare_spell_in_slot(ideal_slots.first, spell_id)
    return true if prepare_spell_in_slot(suboptimal_slots.first, spell_id)
    return false
  end
  
  def prepare_spell_in_slot(slot, spell_id)
    return false unless slot;
    
    case VancianCS::SPELL_PREPARATION_STYLE
    when :by_the_book
      slot[:spell_id] = spell_id
      slot[:expended] = true;
      slot[:replaceable] = false;
    when :readied_slots
      slot[:spell_id] = spell_id
      slot[:expended] = !slot[:replaceable];
      #slot[:replaceable] = false;
    end
    
    return true;
  end
  
  # Prepares a specific spell in a specific slot, WITHOUT ensuring that it's
  #  valid!
  def prepare_spell_in_slot_at_xy(spell_level, spell_row, spell_id)
    slot = get_spell_slot(spell_level, spell_row);
    slot[:level] = $VANCIAN_SPELL_LEVEL
    return prepare_spell_in_slot(slot, spell_id);
  end
  
  def delete_spell_in_slot(slot, spell_id)
    return false unless slot;
    case VancianCS::SPELL_PREPARATION_STYLE
    when :by_the_book
      slot[:spell_id] = nil;
      slot[:expended] = true;
      slot[:replaceable] = true;
    when :readied_slots
      slot[:spell_id] = nil
    end
    return true;
  end
  
  def delete_spell_in_slot_at_xy(spell_level, spell_row, spell_id)
    slot = get_spell_slot(spell_level, spell_row);
    return delete_spell_in_slot(slot, spell_id);
  end
  
  # Expends a prepared spell of id, if possible.
  def use_spell(spell_id)
    row = get_row_by_spell_id(spell_id);
    return false unless row;
    
    row.each do |slot|
      next if slot[:spell_id] && !slot[:replaceable]
      next unless is_slot_available_for_spell?(slot);
      if slot[:replaceable]
        suboptimal_slots.push(slot);
      else
        ideal_slots.push(slot);
      end
    end
  end
  
  def use_slot(slot)
    return false unless slot
    slot[:expended] = true;
    return true
  end
  
  # Expends a spell in the slot (x,y) if it exists.
  def use_slot_at_xy(level, row)
    return use_slot(get_spell_slot(level, row));
  end
  
  def spell_available?(spell_id)
    row = get_row_by_spell_id(spell_id);
    return false unless row;
    
    row.each do |slot|
      next unless slot[:spell_id] == spell_id;
      return true unless slot[:expended]
    end
    return false;
  end
  
  def slot_available?(slot)
    return slot && slot[:expended]
  end
  
  def slot_available_at_xy?(level, row)
    return slot_available?(get_spell_slot(level, row));
  end
  
  def is_slot_available_for_spell?(slot, spell_id,row)
    # apply restrictions here later.
    # restrictions are currently very simple; it's an array of strings
    #  (as tags); at least one of those tags needs equality
    #  i can extend the shit out of it later
    available = true
    restrictions = slot[:restrictions]
    if restrictions
      available = VancianSlotRestrictions.evaluate_restrictions(restrictions, self, slot, spell_id)
    end
    return available
  end
  
  def can_prepare_spell_at_xy?(level, row, spell_id)
    slot = get_spell_slot(level, row);
    available =  false if level != row
    return slot && is_slot_available_for_spell?(slot, spell_id,row);
  end
  
  def can_prepare_spell_in_slot?(slot, spell_id)
    is_slot_available_for_spell?(slot, spell_id,row)
  end
  
end
 
# -----------------------------------------------------------------------------
#  Modifications to RPG::Skill
#  - Stores some extra data about each spell
#
  class RPG::Skill < RPG::UsableItem
    alias_method  :vancecs_init_alias, :initialize
    def initialize
      vancecs_init_alias
    end
    
    def level_tuples
      return @level_tuples if @level_tuples
      
      # [{:level => int, :categories => [], :schools => []}  , ...
      # categories are generic information for stuff like domain spell lists,
      #   weeaboo fightan magic disciplines, etc.
      # schools are for... well take a guess
      
      # tag structure:
      #  vancian_spell: level, category, school [, school ...
      @level_tuples =
        get_note_tags("vancian_spell").map {|instance|
          level, category, *schools = instance.split(",")
          
          {:level => level.to_i,
           :category => category,
           :schools => schools}
          }
          
    end
    
    def schools(category_name)
      temp = level_tuples.select{|x| x[:category] == category_name}.first
      temp && temp[:schools];
    end
    
    def tags(category_name)
      schools(category_name)
    end
    
    def spell_level(category_name)
      temp = level_tuples.select{|x| x[:category] == category_name}.first
      temp && temp[:level];
    end
    
    def is_in_category?(category_name)
      !level_tuples.select{|x| x[:category] == category_name}.empty?
    end
    # predicate/accessor functions here
  end
################################################################################
#------------------------------------------------------------------------------
#| VancianSlotRestrictions : Namespace
#| * Contains functions specifically relating to spell slot restrictions.
#|   Splitting it off into a separate namespace for three reasons:
#|    1. Not cluttering up the other namespace.
#|    2. Allowing a DSL without namespace clutter.
#|    3. Allowing easy extension later.
#------------------------------------------------------------------------------
module VancianSlotRestrictions
  extend self;
  ###################################################################
  # Predicate indexing
  
  def init_predicates
    push_predicate(:tag,"You can memory the spells of this level "){|actor, slot, spell_id, tag|
      if spell_id != nil then
      $data_skills[spell_id].tags(slot[:category]).include?(tag)
      end
    }
    push_predicate(:day_of_the_week,"or below. Press shift to erase spell"){|actor, slot, spell_id, day|
      (Time.now.strftime("%A")) == day
    }
  end
  
  ###################################################################
  
  def evaluate_restrictions(restrictions, actor, slot, spell_id)
    type, *restriction_set = restrictions;
    # In the future, it may be a good idea to refactor this by having each
    #  element be a struct, or something.
    case type
    when 'and', :and
      return restriction_set.inject(true) { |x, new|
        if new[0].is_a?(Symbol)
          x && evaluate_restrictions(new[0], actor, slot, spell_id)
        else
          name, *args = new[0];
          func = get_predicate(name)[:function]
          x && func.call(actor, slot, spell_id, *args);
        end
      }
    when 'or', :or
      return restriction_set.inject(false) { |x, new|
        if new[0].is_a?(Symbol)
          x || evaluate_restrictions(new[0], actor, slot, spell_id)
        else
          name, *args = new[0];
          func = get_predicate(name)[:function]
          x && func.call(actor, slot, spell_id, *args);
        end
      }
    else
      raise "Invalid restriction type; passed #{type}, require 'and' or 'or'."
    end
  end
  
  def evaluate_restriction_proc(key, actor, slot, spell_id, *args)
    # call it generically, and store restriction procs as a symbol + args
    return get_predicate[key][:function] 
  end
  
  ###################################################################
  # Restriction DSL
  # process(&block) -> Array
  #
  # Accepts a block of restriction DSL code, and returns a properly processed
  # restriction array.
  # By default, it creates a :and block.
  def process(&block)
    outer = self;
    process_bare {
      all {
        outer.module_eval(&block);
      }
    }
  end
  # As process(&block), except that it begins with an :or block.
  def process_or(&block)
    outer = self;
    val = process_bare {
      any {
        outer.module_eval(&block);
      }
    }
  end
  # As with process(&block), except that it begins with no block.
  def process_bare(&block)
    @current_pred_list = [];
    self.module_eval(&block)
    return @current_pred_list.first;
  end
  
  # DSL pieces (also if you're wondering, "and" and "or" are reserved words,
  #  otherwise I'd call them that)
  def all(&block)
    old_list = @current_pred_list;
    @current_pred_list = new_list = [:and];
    self.module_eval(&block);    
    @current_pred_list = old_list;
    @current_pred_list.push(new_list);
  end
  
  def any(&block)
    old_list = @current_pred_list;
    @current_pred_list = new_list = [:or];
    self.module_eval(&block);    
    @current_pred_list = old_list;
    @current_pred_list.push(new_list);
  end
  
  def generate_dsl_methods
    # ...
    @predicate_list.each_pair do |k,v|
      define_method(k.to_s) { |*args|
        params = get_predicate(k)[:function].parameters[3..-1]
        if args.length != params.length
          raise "Wrong number of arguments; received #{args.length}; needed #{params.length}."
        end
        
        pass_args = {};
        args.zip(*(params.transpose)).each do |passed, _, arg_key|
          pass_args[arg_key] = passed;
        end
        
        str = get_predicate_string(k, pass_args)
        @current_pred_list.push(
          [[k, *args], str]
        )
      }
    end
  end
  @predicate_list = {};
  
  # ... docs here
  # Predicates must be of the form:
  #  (Actor, Slot, ...extras) -> Boolean
  def push_predicate(key, string, &block)
    raise "Must pass a block!" unless block_given?
    key = key.to_sym
    if @predicate_list.has_key?(key)
      raise "Can't push duplicate keys to the predicate list!"
    end
    @predicate_list[key] = {:function => block, :string => string};
  end
  
  # get_predicate(String or Symbol) -> Boolean
  #
  # Returns a predicate hash with a key corresponding to sym (which can be
  #  either a symbol or a string corresponding to said symbol.)
  # Predicates were discussed earlier.
  def get_predicate(key)
    key = key.to_sym;
    return nil unless @predicate_list.has_key?(key)
    @predicate_list[key]
  end
  
  def get_predicate_string(key, args={})
    pred = get_predicate(key);
    
    name_string = pred[:string]
    args.each_pair do |k,v|
      name_string = name_string.gsub("{#{k.to_s}}", v.to_s)
    end
    
    return name_string
  end
  
###################################################################
  def init
    init_predicates
    generate_dsl_methods
  end
end
################################################################################
#                  NEW CODE ENDS; MONKEY PATCHES BEGIN                         #
#                                                                              #
class RPG::Class < RPG::BaseItem
  alias_method  :vancecs_init_alias, :initialize
  def initialize
    vancecs_init_alias
  end
  # initialize override doesn't seem to work, so we're stuck with caching like so
  def source_table
    return @source_table if @source_table
    @source_table = VancianCS.get_class(get_first_note_tag("vancian_progression"))
  end
end
# -----------------------------------------------------------------------------
class Game_BattlerBase
  include VancianCasting
  
  alias_method  :vancecs_skill_conditions_met?, :skill_conditions_met?
  def skill_conditions_met?(skill)
    vancecs_skill_conditions_met?(skill) && true# ...
  end
end
class Game_Battler < Game_BattlerBase
end
class Game_Actor < Game_Battler
  alias_method  :vancecs_actor_init, :initialize
  def initialize(actor_id)
    vancecs_actor_init(actor_id)
    
    initialize_vancian_casting(self.class.source_table, @level);
  end
  
  #tag: D&D_params
  alias_method  :vancecs_actor_level_up, :level_up
  def level_up
    vancecs_actor_level_up
    update_spell_slots(@level)
    if self.id == 1
      @thac0 = (self.level/7).to_i
      @armor_class = 10 + (self.level/18).to_i
    elsif self.id == 2
      @thac0 = (self.level/5 + self.level / 10).to_i
      @armor_class = 10 + (self.level/15 + self.level/20).to_i
    elsif self.id == 4
      @thac0 = (self.level/5 + self.level / 12).to_i
      @armor_class = 10 + (self.level/15).to_i
    elsif self.id == 5
      @thac0 = (self.level/5 + self.level / 12).to_i
      @armor_class = 10 + (self.level/15 + self.level/30).to_i
    elsif self.id == 6
      @thac0 = (self.level/5 + self.level / 13).to_i
      @armor_class = 10 + (self.level/16).to_i
    elsif self.id == 7
      @thac0 = (self.level/6 + self.level / 12).to_i
      @armor_class = 10 + (self.level/16).to_i
    else
      @thac0 = (self.level/5).to_i
      @armor_class = 10 + (self.level/10).to_i
    end
    
  end
end
class Game_Enemy < Game_Battler
end
################################################################################
VancianSlotRestrictions.init()
VancianCS.init()
VancianCS.verify_config()
