###--------------------------------------------------------------------------###
#  CP Keyboard Input script                                                    #
#  Version 1.0a                                                                #
#                                                                              #
#      Credits:                                                                #
#  Original code by: Neon Black                                                #
#  Modified by:                                                                                 #
#                                                                                                        #
#  This work is licensed under the Creative Commons Attribution-NonCommercial  #
#  3.0 Unported License. To view a copy of this license, visit                 #
#  http://creativecommons.org/licenses/by-nc/3.0/.                             #
#  Permissions beyond the scope of this license are available at               #
#  http://cphouseset.wordpress.com/liscense-and-terms-of-use/.                 #
#                                                                                                                   #
#      Contact:                                                                #
#  NeonBlack - neonblack23@live.com (e-mail) or "neonblack23" on skype         #
###--------------------------------------------------------------------------###
###--------------------------------------------------------------------------###
#      Revision information:                                                   #
#  V1.0a - 11.15.2012                                                          #
#   Input module bug fix                                                       #
#  V1.0 - 8.11.2012                                                            #
#   Split the console and keyboard module                                      #
#  V0.1 - 7.9.2012                                                             #
#   Wrote and debugged main script                                             #
###--------------------------------------------------------------------------###
###--------------------------------------------------------------------------###
#      Instructions:                                                           #
#  Place this script in the "Materials" section of the scripts above main.     #
#  This script adds keyboard usage to your scripts with the use of the new     #
#  "Keyboard" module.  You can do this using both the "Input" module and the   #
#  "Keyboard" module the same way, ie. Keyboard.trigger?(:kA) or               #
#  Input.trigger?(:kA) will both have the same effect.  To specify keyboard    #
#  input on any given key, this script uses the letter "k" followed by the     #
#  name of the key in all caps.  For example, a letter would be ":kA" or       #
#  ":kK" or some other similar form, numbers would be ":k1", ":k2", etc., and  #
#  named keys would be ":kENTER" or some other key name.                       #
#  To see all the available keys, search for the "Ascii" module.               #
###--------------------------------------------------------------------------###
###--------------------------------------------------------------------------###
#  The following lines are the actual core code of the script.  While you are  #
#  certainly invited to look, modifying it may result in undesirable results.  #
#  Modify at your own risk!                                                    #
###--------------------------------------------------------------------------###
$imported = {} if $imported == nil
$imported["CP_KEYBOARD"] = 1.0
module V  ## Checks a virtual key.
  def self.K(key)
    return Ascii::SYM[key]
  end
end
# tag: input
module Ascii  ## Only the keys I bothered to name.  Some have 2 names.
  SYM = { :k0 => 48, :k1 => 49, :k2 => 50, :k3 => 51, :k4 => 52, :k5 => 53,
          :k6 => 54, :k7 => 55, :k8 => 56, :k9 => 57,
          
          :kA => 65, :kB => 66, :kC => 67, :kD => 68, :kE => 69, :kF => 70,
          :kG => 71, :kH => 72, :kI => 73, :kJ => 74, :kK => 75, :kL => 76,
          :kM => 77, :kN => 78, :kO => 79, :kP => 80, :kQ => 81, :kR => 82,
          :kS => 83, :kT => 84, :kU => 85, :kV => 86, :kW => 87, :kX => 88,
          :kY => 89, :kZ => 90,
          
          :kENTER => 13,    :kRETURN => 13,  :kBACKSPACE => 8, :kSPACE => 32,
          :kESCAPE => 27,   :kESC => 27,     :kSHIFT => 16,    :kTAB => 9,
          :kALT => 18,      :kCTRL => 17,    :kDELETE => 46,   :kDEL => 46,
          :kINSERT => 45,   :kINS => 45,     :kPAGEUP => 33,   :kPUP => 33,
          :kPAGEDOWN => 34, :kPDOWN => 34,   :kHOME => 36,     :kEND => 35,
          :kLALT => 164,    :kLCTRL => 162,  :kRALT => 165,    :kRCTRL => 163,
          :kLSHIFT => 160,  :kRSHIFT => 161,
          
          :kLEFT => 37, :kRIGHT => 39, :kUP => 38, :kDOWN => 40,
          
          :kCOLON => 186,     :kAPOSTROPHE => 222, :kQUOTE => 222,
          :kCOMMA => 188,     :kPERIOD => 190,     :kSLASH => 191,
          :kBACKSLASH => 220, :kLEFTBRACE => 219,  :kRIGHTBRACE => 221,
          :kMINUS => 189,     :kUNDERSCORE => 189, :kPLUS => 187,
          :kEQUAL => 187,     :kEQUALS => 187,     :kTILDE => 192,
          
          :kF1 => 112,  :kF2 => 113,  :kF3 => 114, :kF4 => 115, :kF5 => 116,
          :kF6 => 117,  :kF7 => 118,  :kF8 => 119, :kF9 => 120, :kF10 => 121,
          :kF11 => 122, :kF12 => 123,
          
          :kArrows => 224,
        }
end
module Keyboard  ## The DLL file, function, import, and export.
  @key_state = PONY::API::GetKeyState
  @key_paste = PONY::API::GetClipboardData
  
  @trigger = Array.new(256, false)  ## All 3 of the related arrays for checks.
  @press   = Array.new(256, false)
  @repeat  = Array.new(256, 0)
  @checked = false  ## Sets the check state.
  
  def self.update  ## Resets the check state each frame.
    @checked = false
  end
  
  def self.get_key_state  ## Sets the key states.
    @checked = true
    256.times do |vk|  ## All virtual keys are checked.
      check = @key_state.call(vk)  ## Use the DLL to check the key state.
      unless check == 1 or check == 0  ## -128 and -127 would be held down keys.
        unless @press[vk]
          @press[vk] = true  ## Start pressing.
          @trigger[vk] = true  ## Set the trigger.
        else
          @trigger[vk] = false  ## Depress trigger on later frames.
        end
        @repeat[vk] += 1  ## And change the repeat.
      else
        @press[vk] = false  ## Disable all checks on the key.
        @trigger[vk] = false
        @repeat[vk] = 0
      end
    end
  end
  
  def self.press?(sym)  ## Checks if a key <sym> is pressed down.
    return get_symb(sym, :press)
  end
  
  def self.trigger?(sym)  ## Checks trigger as above.
    return get_symb(sym, :trigger)
  end
  
  def self.repeat?(sym)  ## Checks repeat as above.
    return get_symb(sym, :repeat)
  end
  def self.get_symb(sym, type)  ## Check if the <sym> key is <type>.
    res = sym.is_a?(Symbol) ? V.K(sym) : sym  ## Gets the key's numeric.
    return false if res.nil?  ## Returns if key is not accepted.
    get_key_state unless @checked  ## Sets key states.
    
    case type  ## Checks the key by numeric.
    when :press;   return ch_press?(res)
    when :trigger; return ch_trigger?(res)
    when :repeat;  return ch_repeat?(res)
    end
    return false
  end
          ## The three proper checks.  Need a numeric value for a key to check.
  def self.ch_press?(sym)  ## Held down.
    return @press[sym]
  end
  
  def self.ch_trigger?(sym)  ## Pressed this frame.
    return @trigger[sym]
  end
  
  def self.ch_repeat?(sym)  ## Alternates every few frames.
    return true if @repeat[sym] == 1
    return true if (@repeat[sym] >= 24 && (@repeat[sym] % 6) == 0)
    return false
  end
  
  def self.shifted?  ## Checks the state of both shift keys.
    return true if press?(16)
    return true if caps_on?
    return false
  end
  
  def self.caps_on?  ## Checks the state of capslock.
    return true if @key_state.call(20) == 1
    return false
  end
  
  def self.bittype(text)  ## The keys accepted by typing.
    for i in 48..57  ## Numbers.
      if repeat?(i)
        text += add_char(i)
      end
    end
    for i in 65..90  ## Letters.
      if repeat?(i)
        text += add_char(i)
      end
    end
    for i in 186..192  ## Symbols.
      if repeat?(i)
        text += add_char(i)
      end
    end
    for i in 219..222  ## More symbols.
      if repeat?(i)
        text += add_char(i)
      end
    end
    text += " " if repeat?(32)  ## Space.
    if repeat?(8)  ## Backspace.
      text.chop!
    end
    return text
  end
  
  def self.add_char(key)  ## Adds typed characters.
    caps = press?(16)
    case key
    when 48..57
      return (key - 48).to_s unless caps
      return '!' if key == 49
      return '@' if key == 50
      return '#' if key == 51
      return '$' if key == 52
      return '%' if key == 53
      return '^' if key == 54
      return '&' if key == 55
      return '*' if key == 56
      return '(' if key == 57
      return ')' if key == 48
    when 65..90
      string = "abcdefghijklmnopqrstuvwxyz"
      string.swapcase! if caps
      string.swapcase! if caps_on?
      return string[key - 65]
    when 186; return !caps ? ';' : ':'
    when 187; return !caps ? '=' : '+'
    when 188; return !caps ? ',' : '<'
    when 189; return !caps ? '-' : '_'
    when 190; return !caps ? '.' : '>'
    when 191; return !caps ? '/' : '?'
    when 192; return !caps ? '`' : '~'
    when 219; return !caps ? '[' : '{'
    when 220; return !caps ? '\\' : '|'
    when 221; return !caps ? ']' : '}'
    when 222; return !caps ? '\'' : '"'
    end
  end
  
  def self.press_any_key  ## The keys accepted by "any key"
    for i in 48..57
      return true if trigger?(i)
    end
    for i in 65..90
      return true if trigger?(i)
    end
    for i in 186..192
      return true if trigger?(i)
    end
    for i in 219..222
      return true if trigger?(i)
    end
    [13, 22, 27, 192, 32].each {|i| return true if trigger?(i)}
    return false
  end
end
module Input
class << self
  alias cp_keyboard_update update unless $@
  alias cp_keyboard_press? press? unless $@
  alias cp_keyboard_trigger? trigger? unless $@
  alias cp_keyboard_repeat? repeat? unless $@
end
  
  def self.update
    Keyboard.update
    cp_keyboard_update
  end
  
  def self.press?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_press?(*sym)
    else
      sym.any? do |key|
        (Keyboard.press?(key) || cp_keyboard_press?(key))
      end
    end
  end
  
  def self.trigger?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_trigger?(*sym)
    else
      sym.any? do |key|
        (Keyboard.trigger?(key) || cp_keyboard_trigger?(key))
      end
    end
  end
  
  def self.repeat?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_repeat?(*sym)
    else
      sym.any? do |key|
        (Keyboard.repeat?(key) || cp_keyboard_repeat?(key))
      end
    end
  end
  
end
module Input
  
  class << self; alias :trigger_wasd? :trigger?; end
  def self.trigger?(sym)
    case sym
    when :UP;     return trigger_wasd?(sym) || trigger_wasd?(:kW);
    when :LEFT;   return trigger_wasd?(sym) || trigger_wasd?(:kA);
    when :DOWN;   return trigger_wasd?(sym) || trigger_wasd?(:kS);
    when :RIGHT;  return trigger_wasd?(sym) || trigger_wasd?(:kD);
    when :R;      return trigger_wasd?(sym) || trigger_wasd?(:kE);
    else;         return trigger_wasd?(sym);
    end
  end
  
  class << self; alias :press_wasd? :press?; end
  def self.press?(sym)
    case sym
    when :UP;     return press_wasd?(sym) || press_wasd?(:kW);
    when :LEFT;   return press_wasd?(sym) || press_wasd?(:kA);
    when :DOWN;   return press_wasd?(sym) || press_wasd?(:kS);
    when :RIGHT;  return press_wasd?(sym) || press_wasd?(:kD);
    when :R;      return press_wasd?(sym) || press_wasd?(:kE);
    else;         return press_wasd?(sym);
    end
  end
  
  class << self; alias :repeat_wasd? :repeat?; end
  def self.repeat?(sym)
    case sym
    when :UP;     return repeat_wasd?(sym) || repeat_wasd?(:kW);
    when :LEFT;   return repeat_wasd?(sym) || repeat_wasd?(:kA);
    when :DOWN;   return repeat_wasd?(sym) || repeat_wasd?(:kS);
    when :RIGHT;  return repeat_wasd?(sym) || repeat_wasd?(:kD);
    when :R;      return repeat_wasd?(sym) || repeat_wasd?(:kE);
    else;         return repeat_wasd?(sym);
    end
  end
end
###--------------------------------------------------------------------------###
#  End of script.                                                              #
###--------------------------------------------------------------------------###
