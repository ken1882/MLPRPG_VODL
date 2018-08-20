#==============================================================================
# * Game mode configuration
#==============================================================================
#tag: game_mode
module PONY::GameMode
  #------------------------------------------------------------------------------
  GameMode = Struct.new(:symbol, :name, :image, :enabled, :help, :init_map_id,
                        :sx, :sy, :init_party)
  #------------------------------------------------------------------------------
  Modes = []
  CursorImage = "Mode_Frame"
  #------------------------------------------------------------------------------
  Tone_VODL     = Tone.new(0,0,155)
  Tone_Tutorial = Tone.new(0,0,0)
  #------------------------------------------------------------------------------
  CreditMapID   = 26
  
  ModeConfig = {
    :main => # Mode Symbol
    {
      :name         => Vocab::VODL,       # Mode name
      :image        => "Mode_VODL",       # Path to display image file
      :enabled      => true,              # Enabled?
      :help         => Vocab::VODLHelp,   # Help text
      :init_map_id  => nil,               # Starting map id, nil for default
      :sx           => nil,               # Starting x corrd, nil for default
      :sy           => nil,               # Starting y coord, nil for default
      :init_party   => nil,               # Starting party member id, nil for deafult
    },
    #-----------
    :tutorial => 
    {
      :name         => Vocab::Tutorial,
      :image        => "Mode_Tutorial",
      :enabled      => true,
      :help         => Vocab::TutorialHelp,
      :init_map_id  => 27,
      :sx           => 5,
      :sy           => 0,
      :init_party   => nil,
    },
    #-----------
  }
  #------------------------------------------------------------------------------
  def self.setup_modes
    #-- roll credits
    setup_credit
    #-- push modes to list
    @modes = []
    ModeConfig.each do |symbol, info|
      mode = GameMode.new(symbol)
      mode.name         = info[:name]
      mode.image        = info[:image]
      mode.enabled      = info[:enabled]
      mode.help         = info[:help]
      mode.init_map_id  = info[:init_map_id]
      mode.sx, mode.sy  = info[:sx], info[:sy]
      mode.init_party   = info[:init_party]
      @modes << mode
    end
    const_set(:Modes, @modes)
  end
  #------------------------------------------------------------------------------
  def self.setup_credit
    mode_credit             = GameMode.new(:credits)
    mode_credit.name        = Vocab::Credits
    mode_credit.image       = nil
    mode_credit.enabled     = true
    mode_credit.help        = nil
    mode_credit.init_map_id = CreditMapID
    mode_credit.init_party  = nil
    mode_credit.sx, mode_credit.sy = 0, 0
    const_set(:ModeCredit, mode_credit)
  end
  #------------------------------------------------------------------------------
  def init_gamemode(mode_symbol)
    debug_print("Start mode: #{mode_symbol}, is_credit: #{mode_symbol == :credits}")
    mode = mode_symbol == :credits ? ModeCredit : Modes.find{|m| m.symbol == mode_symbol}
    debug_print("Current mode: #{mode}")
    $game_system.game_mode = mode.symbol
    DataManager.setup_new_game(mode)
  end
  #------------------------------------------------------------------------------
  setup_modes
end
