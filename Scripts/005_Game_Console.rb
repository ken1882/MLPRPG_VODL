#===============================================================================
# * Game_Console
#===============================================================================
#tag: console
class Game_Console
  #----------------------------------------------------------------------------
  attr_reader :show_roll_result, :debug_mode
  attr_reader :skip_loading, :focus
  #----------------------------------------------------------------------------
  def initialize
    load_ini
    @hwnd = PONY::API::Hwnd
  end
  #----------------------------------------------------------------------------
  def load_ini
    group = "Option"
    @show_roll_result = FileManager.load_ini(group, 'ShowRollResult').to_i.to_bool
    @debug_mode       = FileManager.load_ini(group, 'DebugMode').to_i.to_bool
    @skip_loading     = FileManager.load_ini(group, 'SkipLoading').to_i.to_bool
    load_volume
  end
  #----------------------------------------------------------------------------
  def load_volume
    begin
      volume = FileManager.load_ini('Option', 'Volume')
      volume = volume.split(/[\[\]]/).at(1)
      volume = volume.split(',').collect{|i| i.to_i}
    rescue Exception => e
      volume = [100, 100, 100]
    end
    volume = [100, 100, 100] if !volume
    (volume.size).times do |i| $sound_volume[i] = volume[i] end    
    puts("Volume:", $sound_volume)
  end
  #----------------------------------------------------------------------------
  def skip_loading?
    return @skip_loading
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
  def focused?
    @focus
  end
  #----------------------------------------------------------------------------
end
