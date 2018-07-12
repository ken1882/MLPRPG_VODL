#==========================================================================
# ■ RPG::BaseItem
#--------------------------------------------------------------------------
#   This class is the super class of all database classes
#==========================================================================
class RPG::BaseItem
  include DND::Utility
  #------------------------------------------------------------------------
  # * public instance variables
  #------------------------------------------------------------------------
  # tag: equiparam
  attr_accessor :user_graphic        # Graphic display on user
  attr_accessor :tool_cooldown       # Cooldown after use
  attr_accessor :tool_graphic        # Projectile graphic
  attr_accessor :weapon_skill        # Skill apply when weapon hitted
  attr_accessor :tool_index          # Projectile graphic index
  attr_accessor :tool_distance       # Effective distance
  attr_accessor :tool_effectdelay    # Effect delay after exeucuted (frame)
  attr_accessor :tool_destroydelay   # Graphic removal delay after completed
  attr_accessor :tool_speed          # Projectile speed
  attr_accessor :tool_castime        # Cast time
  attr_accessor :tool_castanimation  # Animation during casting
  attr_accessor :tool_blowpower      # Knockback enemy when hitted
  attr_accessor :tool_piercing       # Pierece amount of effect executed
  
  attr_accessor :tool_animation      # Animation display on collide
  attr_accessor :tool_animmoment     # Animation display moment
                                     # 1: Display on projectile
                                     # 0: Display on recipient
                                      
  attr_accessor :tool_special        # Special attributes
  attr_accessor :tool_special_param  # 0: Nothing
                                     # 1: Projectile jump to neartest next
                                     # target, parameter: max jump count
                                     #
                                     # 2: Projectile will reflect after collide
                                     # parameter: max reflection count
                                      
  attr_accessor :tool_scope          # Effective scope range on execute
  attr_accessor :tool_scopedir       # Effective direction, 0 = same as battler
                                     # direction = 1~9, 5 = all direction
                                     
  attr_accessor :tool_scopeangle     # 0 = all_direction, 1~359 otherwise
  attr_accessor :tool_invoke         # Invoke other skill(id) on execute
  attr_accessor :tool_soundeffect    # Sound effect played on execuute
  attr_accessor :tool_itemcost       # Specified item(id) required
  attr_accessor :tool_itemcost_type  # Item type(id) required
  attr_accessor :tool_through        # Projectile through map obstacles
  attr_accessor :tool_priority       # Graphic priority display, same as event's
  attr_accessor :tool_hitshake       # Screen shake level when hitted (uint)
  attr_accessor :tool_type           # Tool Type, 0 = missile, 1 = bomb
  attr_accessor :tool_combo          # Next Weapon id use after player contiune
                                     # to using this tool(default: in 20 frames)
                                     
  attr_reader   :scope               # Damage::Scope
  attr_reader   :information         # Linked to folder /History
  attr_reader   :action_sequence
  attr_reader   :dmg_saves           # Saving throw type when executed
  #------------------------------------------------------------------------
  attr_reader :saving_throw_adjust
  attr_reader :dc_adjust
  attr_reader :property
  attr_reader :damage_index
  attr_reader :item_own_max
  attr_reader :param_adjust, :thac0, :ac
  #---------------------------------------------------------------------------
  # * Load the attributes of the item form its notes in database
  #---------------------------------------------------------------------------
  def load_notetags_dndattrs
    @feature_value = {}
    apply_default_tool_attrs
    
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #-------------------------------------------------------------------------
      # * Base score ability adjustment when processing saving throws
      when DND::REGEX::SAVING_THROW_ADJUST
        @saving_throw_adjust = $1.split(',').collect{|i| i.to_i}
      #-------------------------------------------------------------------------
      # * Base score ability adjustment when processing difficulty classes
      when DND::REGEX::DC_ADJUST
        @dc_adjust = $1.split(',').collect{|i| i.to_i}
      #-------------------------------------------------------------------------
      # * Base score ability adjustment
      when DND::REGEX::Param_Adjust
        @param_adjust            = $1.split(',').collect{|i| i.to_i}
      #-------------------------------------------------------------------------
      # * Projectile produced by this item whether blocked by event
      when DND::REGEX::PROJ_BLOCK_BY_EVENT; @block_by_event = true
      #-------------------------------------------------------------------------
      # * Item max for EquipItem and Items
      when DND::REGEX::ITEM_MAX;            @item_own_max = $1.to_i
      #-------------------------------------------------------------------------
      # * Damage inflicted by this item
      when DND::REGEX::DAMAGE
        element_id = get_element_id($3)
        time = $1.split('d').at(0)
        face = $1.split('d').at(1)
        mod_id = get_param_id($4)
        @damage_index.push( [time.to_i,face.to_i,$2.to_i,element_id,mod_id])
        puts "[BaseItem Damage]:#{self.name}: #{time}d#{face} + (#{$2.to_i}), element:#{$3}(#{element_id}) modifier: #{$4}(#{mod_id})"
      else
        load_item_property(line)
      end
    } # self.note.split
    
    # Minor adjusts
    @tool_distance     += 0.4
    @tool_scope        += 0.4
    @information = load_help_information
  end
  #---------------------------------------------------------------------------
  # * Load item's property, presented by a bitset
  #---------------------------------------------------------------------------
  def load_item_property(line)
    case line
    when DND::REGEX::MAGIC_EFFECT
      @property |= PONY::Bitset[0]
    when DND::REGEX::DEBUFF && self.is_a?(RPG::State)
      @property |= PONY::Bitset[1]
    when DND::REGEX::POISON && self.is_a?(RPG::State)
      @property |= PONY::Bitset[2]
    when DND::REGEX::IS_PHYSICAL
      @property |= PONY::Bitset[3]
    when DND::REGEX::IS_MAGICAL
      @property |= PONY::Bitset[4]
    when DND::REGEX::Leveling::Leveling
      @property |= PONY::Bitset[5]
    end
    load_item_features(line)
  end
  #---------------------------------------------------------------------------
  # * Load core tool item feature
  #---------------------------------------------------------------------------
  def load_item_features(line)
    case line
    when DND::REGEX::Equipment::UserGraphic
      @user_graphic = $1.downcase == 'nil' ? nil : $1
    when DND::REGEX::Equipment::ToolGraphic
      @tool_graphic = $1.downcase == 'nil' ? nil : $1
    when DND::REGEX::Equipment::WeaponEffect;      @weapon_skill       = $1.to_i;
    when DND::REGEX::Equipment::ToolIndex;         @tool_index         = $1.to_i;
    when DND::REGEX::Equipment::CoolDown;          @tool_cooldown      = $1.to_i;
    when DND::REGEX::Equipment::ToolDistance;      @tool_distance      = $1.to_i;
    when DND::REGEX::Equipment::ToolEffectDelay;   @tool_effectdelay   = $1.to_i;
    when DND::REGEX::Equipment::ToolDestroyDelay;  @tool_destroydelay  = $1.to_i;
    when DND::REGEX::Equipment::ToolSpeed;         @tool_speed         = $1.to_f;
    when DND::REGEX::Equipment::ToolCastime;       @tool_castime       = $1.to_i;
    when DND::REGEX::Equipment::ToolCastAnimation; @tool_castanimation = $1.to_i;
    when DND::REGEX::Equipment::ToolBlowPower;     @tool_blowpower     = $1.to_i;
    when DND::REGEX::Equipment::ToolPiercing;      @tool_piercing      = $1.to_i;
    when DND::REGEX::Equipment::ToolAnimation;     @tool_animation     = $1.to_i;    
    when DND::REGEX::Equipment::ToolAnimMoment;    @tool_animmoment    = $1.to_i;
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolSpecial
      @tool_special       = $1.to_i
      @tool_special_param = $2.to_i | 0
    #---------------------------------------------------------------------------
    when DND::REGEX::Equipment::ToolScope;         @tool_scope         = $1.to_i;
    when DND::REGEX::Equipment::ToolScopeDir;      @tool_scopedir      = $1.to_i;
    when DND::REGEX::Equipment::ToolScopeAngle;    @tool_scopeangle    = $1.to_i;
    when DND::REGEX::Equipment::ToolInvokeSkill;   @tool_invoke        = $1.to_i;
    when DND::REGEX::Equipment::ToolSE
      @tool_soundeffect[0] = $1 unless $1.strip.downcase == 'nil'
      @tool_soundeffect[1] = $2.to_i if $2
    when DND::REGEX::Equipment::ToolItemCost;      @tool_itemcost      = $1.to_i;
    when DND::REGEX::Equipment::ToolItemCostType;  @tool_itemcost_type = $1.to_i;
    when DND::REGEX::Equipment::ToolThrough;       @tool_through       = $1.to_i.to_bool;
    when DND::REGEX::Equipment::ToolPriority;      @tool_priority      = $1.to_i;
    when DND::REGEX::Equipment::ToolType;          @tool_type          = $1.to_i; 
    when DND::REGEX::Equipment::ToolHitShake;      @tool_hitshake      = $1.to_i;
    when DND::REGEX::Equipment::ToolCombo;         @tool_combo         = $1.to_i;
    when DND::REGEX::Equipment::ApplyAction;       @action_sequence    = $1.to_i;
    when DND::REGEX::Equipment::DamageSavingThrow
      @dmg_saves = [DND::SavingThrow::List[$1], $2]
    end
  end  
  #---------------------------------------------------------------------------
  # * Default attributes for tool item
  #---------------------------------------------------------------------------
  def apply_default_tool_attrs
    @saving_throw_adjust      = Array.new(8, 0)
    @dc_adjust                = Array.new(8, 0)
    @param_adjust             = Array.new(8, 0)
    
    @damage_index             = []
    @property                 = 0
    @item_own_max             = 10
    
    @tool_animation     = 0
    @tool_distance      = 2
    @tool_animmoment    = 0
    @tool_castime       = 0
    @tool_itemcost      = 0
    @tool_itemcost_type = 0
    @tool_scope         = 1
    @tool_scopedir      = 5
    @tool_scopeangle    = 0
    @tool_blowpower     = 0
    @tool_combo         = 0
    @action_sequence    = 0
    @tool_effectdelay   = 0
    @tool_itemcost      = 0
    @tool_itemcost_type = 0
    @dmg_saves          = nil
    @tool_soundeffect   = [nil, 80]
    @block_by_event     = false
  end
  #---------------------------------------------------------------------------
  # *) Load item infos for detailed inforamtion, located at "History/type/id"
  # -> virtual function for inherit
  #---------------------------------------------------------------------------  
  def load_help_information
  end
  #------------------------------------------------------------------------
  # * Super mehtod for characters initialization
  #------------------------------------------------------------------------
  def load_character_attributes
    @feature_value = {}
  end
  #------------------------------------------------------------------------
  # *) Item need consume items
  #------------------------------------------------------------------------  
  def item_required?
    return (@tool_itemcost || 0) > 0 || (@tool_itemcost_type || 0) > 0
  end
  #------------------------------------------------------------------------
  # *) Item is an ammo?
  #------------------------------------------------------------------------  
  def is_ammo?
    return false if !self.is_a?(RPG::Weapon)
    _id = self.wtype_id
    return [11, 12, 13].include?(_id) # arrow, bolt, 
  end
  #------------------------------------------------------------------------
  def is_magic?
    return (@property & PONY::Bitset[0]).to_bool
  end
  #------------------------------------------------------------------------
  def is_debuff?
    return (@property & PONY::Bitset[1]).to_bool
  end
  #------------------------------------------------------------------------
  def is_poison?
    return (@property & PONY::Bitset[2]).to_bool
  end
  #------------------------------------------------------------------------
  # * Whether a virtual flag for leveling
  #------------------------------------------------------------------------
  def for_leveling?
    return (@property & PONY::Bitset[5]).to_bool
  end
  #------------------------------------------------------------------------
  def is_spell?
    return false if self.nil?
  end
  #------------------------------------------------------------------------
  def attack_type
    return :magic  if is_magic?
    return :melee  if melee?
    return :ranged
  end
  #------------------------------------------------------------------------
  def melee?
    return @tool_distance < 2.5
  end
  #--------------------------------------------------------------------------
  def ranged?
    return !melee?
  end
  #---------------------------------------------------------------------------
  def physical?
    return (@property & PONY::Bitset[3]).to_bool
  end
  #---------------------------------------------------------------------------
  def magical?
    return (@property & PONY::Bitset[4]).to_bool
  end
  #--------------------------------------------------------------------------
  def param(id)
    return param_base(id)
  end
  #---------------------------------------------------------------------------
  def param_base(id)
    value = @param_adjust[id]
    value
  end
  #--------------------------------------------------------------------------
  def feature_value(code, data_id)
    key = code * 1000 + data_id
    return @feature_value[key] unless @feature_value[key].nil?
    value = 0
    @features.each do |feat|
      next unless feat.code == code && feat.data_id == data_id
      value += feat.value
    end
    return @feature_value[key] = value
  end
  #--------------------------------------------------------------------------
  def attack_bonus
    return (self.feature_value(22, 0) * 20).to_i
  end
  #--------------------------------------------------------------------------
  def armor_class
    return (self.feature_value(22, 1) * 20).to_i
  end
  #---------------------------------------------------------------------------
  def wield_speed
    return 60 - @tool_cooldown
  end
  #--------------------------------------------------------------------------
  # Item Scope Queries
  #--------------------------------------------------------------------------
  def for_none?; return @scope == 0; end
  def for_opponent?; return [1, 2, 3, 4, 5, 6].include?(@scope); end
  def for_friend?; return [7, 8, 9, 10, 11].include?(@scope); end
  def for_dead_friend?; return [9, 10].include?(@scope); end
  def for_user?; return @scope == 11; end
  def for_one?; return [1, 3, 7, 9, 11].include?(@scope); end
  def for_random?; return [3, 4, 5, 6].include?(@scope); end
  def for_all?; return [2, 8, 10].include?(@scope); end
  #--------------------------------------------------------------------------
end
