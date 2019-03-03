#===============================================================================
# * GameManager
#===============================================================================
module GameManager
  #----------------------------------------------------------------------------
  @debug_mode       = false
  @show_roll_result = false
  @skip_loading     = false
  @focus            = true
  @hwnd             = nil
  #----------------------------------------------------------------------------
  module_function
  def initialize
    self.load_ini
    @hwnd = PONY::API::Hwnd
  end
  #----------------------------------------------------------------------------
  def load_ini
    group = "Option"
    @show_roll_result = FileManager.load_ini(group, 'ShowRollResult').to_i.to_bool
    @debug_mode       = FileManager.load_ini(group, 'DebugMode').to_i.to_bool
    @skip_loading     = FileManager.load_ini(group, 'SkipLoading').to_i.to_bool
    puts "Ini loaded"
    puts "#{@debug_mode} #{@skip_loading}"
    self.load_volume
  end
  #----------------------------------------------------------------------------
  def load_volume
    Sound.set_volume(100,100,100)
    begin
      volume = FileManager.load_ini('Option', 'Volume')
      volume = volume.split(/[\[\]]/).at(1)
      volume = volume.split(',').collect{|i| i.to_i}
    rescue Exception => e
      volume = [100, 100, 100]
    end
    volume = [100, 100, 100] if !volume
    Sound.set_volume(*volume)
    puts("Volume:", Sound.volume)
  end
  #----------------------------------------------------------------------------
  def get_language_setting
    raw = FileManager.load_ini('Option', 'Language').purify.downcase.to_sym
    puts "Language Changed: #{raw}"
    return $supported_languages.keys.include?(raw) ? raw : :en_us
  end
  #--------------------------------------------------------------------------
  def update_focus
    chwnd  = PONY::API::GetFocus.call(0)
    @focus = chwnd == @hwnd || ($input_hwnd && $input_hwnd == chwnd)
  end
  #----------------------------------------------------------------------------
  def skip_loading?
    return @skip_loading || ($game_system && ($game_system.game_mode == :credits))
  end
  #----------------------------------------------------------------------------
  # * Getter query functions
  #----------------------------------------------------------------------------
  def show_roll_result?; @show_roll_result; end
  def focused?; @focus; end
  def debug_mode?; @debug_mode; end
  #----------------------------------------------------------------------------
end