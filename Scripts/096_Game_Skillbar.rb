#===============================================================================
# * PONY::SkillBar
#-------------------------------------------------------------------------------
#   Tool/SkillBar Set up 
#===============================================================================
module PONY::SkillBar
  # Layout graphic
  LayoutImage = "Skillbar"
  
  # Follower attack command icon index
  FollowerIcon = 116
  
  AllSkillIcon = 143
  VancianIcon  = 141
  AllItemIcon  = 1528
  
  HotKeySelection = 1
  AllSelection    = 2
  CastSelection   = 3
  
  Follower_Flag = 0xff
  AllItem_Flag  = 0xaf
  AllSkill_Flag = 0xbf
  Vancian_Flag  = 0xcf
  
  LastPage_Flag = 0xdf
  NextPage_Flag = 0xef
  
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
end
#===============================================================================
# * HotKeys
#-------------------------------------------------------------------------------
#   Hot Key Settings
#===============================================================================
module HotKeys
  
  Weapon       = :kR
  Armor        = :kF
  HotKeys      = [:k1, :k2, :k3, :k4, :k5, :k6, :k7, :k8, :k9, :k0]
  AllSkills    = :kTILDE
  AllItems     = :kMINUS
  Vancians     = :kEQUAL
  SwitchMember = [:kF3, :kF4, :kF5]
  QuickSave    = :kF7
  QuickLoad    = :kF8
  Follower     = :kC
  
  SkillBar     = [Weapon, Armor, Follower, AllSkills, HotKeys, AllItems, Vancians].flatten
  SkillBarSize = SkillBar.size
  
  Menu         = :kESC
  Journal      = :kJ
  Inventory    = :kI
  Talents      = :kT
  Pause        = :kSPACE
  
  Letter = {
    :kCOLON => ':',        :kAPOSTROPHE => 39.chr, :kQUOTE => 39.chr,
    :kCOMMA => ',',        :kPERIOD => '.',        :kSLASH => 47.chr,
    :kBACKSLASH => 92.chr, :kLEFTBRACE => '(',     :kRIGHTBRACE => ')',
    :kMINUS => '-',        :kUNDERSCORE => '_',    :kPLUS => '+',
    :kEQUAL => '=',        :kEQUALS => '=',        :kTILDE => '~',
  }  
  
  def self.name(key)
    Letter.each do  |name, ch|
      return ch if key == name
    end
    base = key.to_s
    base = base[1].upcase + base[2...base.length].downcase
    return base
  end
  
  def self.tool_index(key)
    return if key.nil?
    n = SkillBar.size
    for i in 0...n
      return i if key == SkillBar[i]
    end
  end
  
end
#===============================================================================
# * Game_SkillBar
#-------------------------------------------------------------------------------
#   Skill bar object that handle the actions triggered in skill bar.
#===============================================================================
class Game_Skillbar
  include PONY::SkillBar
  #--------------------------------------------------------------------------
  # *) Instance Vars
  #--------------------------------------------------------------------------
  attr_accessor :actor 
  attr_accessor :stack
  attr_accessor :sprite
  attr_accessor :items
  #--------------------------------------------------------------------------
  # *) Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @actor = nil
    @stack = []
    @items = []
    @index = HotKeys::SkillBar
    @tol_col = HotKeys::SkillBarSize
    @bot_col = 0
  end
  #--------------------------------------------------------------------------
  def create_layout(viewport)
    @sprite = Sprite_Skillbar.new(viewport, self)
  end
  #--------------------------------------------------------------------------
  def dispose_layout
    return unless @sprite
    @sprite.dispose
    @sprite = nil
  end
  #--------------------------------------------------------------------------
  # *) Object Update
  #--------------------------------------------------------------------------
  def update
    refresh if @actor != $game_player.actor
    @sprite.update if @sprite && !@sprite.disposed?
    process_input
  end
  #--------------------------------------------------------------------------
  # *) Refresh
  #--------------------------------------------------------------------------
  def refresh
    @actor  = $game_player.actor
    @skills = @actor.skills
    @usableitems = $game_party.items
    @stack.clear
    @stack[0] = @actor
    refresh_item
    @sprite.refresh if @sprite && !@sprite.disposed?
  end
  #--------------------------------------------------------------------------
  # *) Refresh items
  #--------------------------------------------------------------------------
  def refresh_item
    
    case @stack.size
    when HotKeySelection
      @first_scan_index = 0
      @items = @actor.get_hotkeys
      @items.push(AllItem_Flag)
      @items.push(Vancian_Flag)
      @items.insert(2, AllSkill_Flag)
      @items.insert(2, Follower_Flag)
    when AllSelection || CastSelection
      # under contruction
    end
    
  end
  #--------------------------------------------------------------------------
  # *) Process Input
  #--------------------------------------------------------------------------
  def process_input
    for i in @first_scan_index...HotKeys::SkillBarSize
      select(i) if Input.trigger?(HotKeys::SkillBar[i]) || Mouse.trigger_skillbar?(i)
    end
  end
  #--------------------------------------------------------------------------
  # *) Select item
  #--------------------------------------------------------------------------
  def select(index)
    puts "Selet: #{index}"
    case @stack.size
    when HotKeySelection
      @bot_col = select_hotkey(index)
    when AllSelection || CastSelection
      
    end
  end
  #--------------------------------------------------------------------------
  # *) Select item in hotkey phase
  #--------------------------------------------------------------------------
  def select_hotkey(index)
    return process_skill_select     if @items[index] == AllSkill_Flag
    return process_item_select      if @items[index] == AllItem_Flag
    return process_vancian_select   if @items[index] == Vancian_Flag
    return process_follower_action  if @items[index] == Follower_Flag
    return process_item_use(@items[index])
  end
  #--------------------------------------------------------------------------
  def process_skill_select
    return 0
    #tag: queued
    @stack.push(AllSkill_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_item_select
    return 0
    @stack.push(AllItem_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_vancian_select
    # tag: under construction
    return 0
    @stack.push(Vancian_Flag)
    
    return 2
  end
  #--------------------------------------------------------------------------
  def process_follower_action
    $game_player.followers.into_fray
  end
  #--------------------------------------------------------------------------
  def process_item_use(item)
    @actor.process_tool_action(item)
    
  end
  
end
