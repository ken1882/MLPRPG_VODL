# This contains:
# - A GameJolt API wrapper
# - All required scripts
# Please see http://gamejolt.com/games/other/gamejolt-achievement-api-for-rpg-maker-vx-ace/40546/
# for more information.
# Credits
# Please credit the following people:
# EFE's Request Script: efeberk, Ryex, Gustavo Bicalho, Kubiwa Taicho
# MD5: Script by Orochii Zouveleki and
# "derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm"
# JSON: game_guy
# Text Input: Tsukihime
# Game Custom Data: Lanthanum Entertainment / Adiktuzmiko
# You can also credit me, Florian van Strien, for making the RPG Maker VX Ace
# GameJolt API, but that's not required (it'd be appreciated though!).
module GameJolt
  # Change these for your game
  GameId = "134888"
end
# Please note that this script has been modified slightly to allow responses up
# to 1 MB. This does make the script slower, but it was needed to prevent crashes.
=begin
===============================================================================
 EFE's Request Script
 Version: RGSS & RGSS2 & RGSS3
 Special thanks : Ryex, Gustavo Bicalho, Kubiwa Taicho
===============================================================================
 This script will allow to request to some servers WITHOUT posting.(Only GET)
--------------------------------------------------------------------------------
Used WINAPI functions:
WinHTTPOpen
WinnHTTLConnect
WinHTTPOpenRequest
WinHTTPSendRequest
WinHTTPReceiveResponse
WinHttpQueryDataAvailable
WinHttpReadData
Call:
EFE.request(host, path, post, port)
host : "www.rpgmakervxace.net" (without http:// prefix)
path : "/forum/login.php" ( the directory path of your php file )
post : "username=kfdsfdsl&password=24324234"
port : 80 is default.
=end
module EFE
  
  # I took this method from Gustavo Bicalho's WebKit script. Special thanks him.
  def self.to_ws(str)
    str = str.to_s();
    wstr = "";
    for i in 0..str.size
      wstr += str[i,1]+"\0";
    end
    wstr += "\0";
    return wstr;
  end
  
  
  
  #EFES_WINAPI = Win32API.new('ods', 'naber', 'pp', 'p')
  WinHttpOpen = Win32API.new('winhttp','WinHttpOpen',"PIPPI",'I')
  WinHttpConnect = Win32API.new('winhttp','WinHttpConnect',"PPII",'I')
  WinHttpOpenRequest = Win32API.new('winhttp','WinHttpOpenRequest',"PPPPPII",'I')
  WinHttpSendRequest = Win32API.new('winhttp','WinHttpSendRequest',"PIIIIII",'I')
  WinHttpReceiveResponse = Win32API.new('winhttp','WinHttpReceiveResponse',"PP",'I')
  WinHttpQueryDataAvailable = Win32API.new('winhttp', 'WinHttpQueryDataAvailable', "PI", "I")
  WinHttpReadData = Win32API.new('winhttp','WinHttpReadData',"PPIP",'I')
  #WinHttpWriteData = Win32API.new('winhttp','WinHttpWriteData',"PPIP",'I')
  def self.request2(host, path, post="")
    pr = path
    if(post != "")
      pr = pr + "?" + post
    end
    pr = pr.to_s
    a = EFES_WINAPI.call(to_ws(host), to_ws(pr))
    return a
  end
  
  def self.request(host, path, post="",port=80)
    p = path
    if(post != "")
      p = p + "?" + post
    end
    p = p.to_s
    pwszUserAgent = ''
    pwszProxyName = ''
    pwszProxyBypass = ''
    httpOpen = WinHttpOpen.call(pwszUserAgent, 0, pwszProxyName, pwszProxyBypass, 0)
    if httpOpen
      httpConnect = WinHttpConnect.call(httpOpen, to_ws(host), port, 0)
      if httpConnect
        httpOpenR = WinHttpOpenRequest.call(httpConnect, nil, to_ws(p), "", '',0,0)
        if httpOpenR
          httpSendR = WinHttpSendRequest.call(httpOpenR, 0, 0 , 0, 0,0,0)
          if httpSendR
            httpReceiveR = WinHttpReceiveResponse.call(httpOpenR, nil)
            if httpReceiveR
              received = 0
              httpAvailable = WinHttpQueryDataAvailable.call(httpOpenR, received)
              if httpAvailable
                # I know this might be an ugly solution, but it does seem to be much faster than ' ' * 1048576
                ali = '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ' * 512 #modified this from 1024
                n = 0
                httpRead = WinHttpReadData.call(httpOpenR, ali, 1048576, o=[n].pack('i!')) # That number was 1024
                n=o.unpack('i!')[0]
                return ali[0, n]
              else
                msgbox_p("Error about query data available")
              end
            else
              msgbox_p("Error when receiving response")
            end
          else
            msgbox_p("Error when sending request")
          end
            
        else
          msgbox_p("Error when opening request")
        end
          
      else
        msgbox_p("Error when connecting to the host")
      end
        
    else
      msgbox_p("Error when opening connection")
    end
  end
end
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# WebRequest Script
#------------------------------------------------------------------------------
# Author: efeberk
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
#   
#  This work is protected by the following license:
# #----------------------------------------------------------------------------
# #  
# #  Creative Commons - Attribution-NonCommercial-ShareAlike 3.0 Unported
# #  ( http://creativecommons.org/licenses/by-nc-sa/3.0/ )
# #  
# #  You are free:
# #  
# #  to Share - to copy, distribute and transmit the work
# #  to Remix - to adapt the work
# #  
# #  Under the following conditions:
# #  
# #  Attribution. You must attribute the work in the manner specified by the
# #  author or licensor (but not in any way that suggests that they endorse you
# #  or your use of the work).
# #  
# #  Noncommercial. You may not use this work for commercial purposes.
# #  
# #  Share alike. If you alter, transform, or build upon this work, you may
# #  distribute the resulting work only under the same or similar license to
# #  this one.
# #  
# #  - For any reuse or distribution, you must make clear to others the license
# #    terms of this work. The best way to do this is with a link to this web
# #    page.
# #  
# #  - Any of the above conditions can be waived if you get permission from the
# #    copyright holder.
# #  
# #  - Nothing in this license impairs or restricts the author's moral rights.
# #  
# #----------------------------------------------------------------------------
# 
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# If you find any bugs, please report them here:
# http://www.rpgmakervxace.net
# or skype: oceanjack35
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
# http://forum.chaos-project.com/index.php?topic=13031.0
module ZOMD5
  #@createMD5string = PONY::MD5
  def self.calc_md5(string)
    #md5 = " "*128
    #@createMD5string.call(string, md5)
    #md5.unpack("A*")
    return PONY.MD5(string)
  end
  
  def self.url
    url = calc_md5("http://gamejolt.com/api/game/v1/")
    url[0]
  end
  
end
#===============================================================================
# JSON Encoder/Decoder
# Version 1.1
# Author: game_guy
#-------------------------------------------------------------------------------
# Intro:
# JSON (JavaScript Object Notation) is a lightweight data-interchange 
# format. It is easy for humans to read and write. It is easy for machines to 
# parse and generate.
# This is a simple JSON Parser or Decoder. It'll take JSON thats been 
# formatted into a string and decode it into the proper object.
# This script can also encode certain ruby objects into JSON.
#
# Features:
# Decodes JSON format into ruby strings, arrays, hashes, integers, booleans.
#
# Instructions:
# This is a scripters utility. To decode JSON data, call
# JSON.decode("json string")
# -Depending on "json string", this method can return any of the values:
#  -Integer
#  -String
#  -Boolean
#  -Hash
#  -Array
#  -Nil
#
# To Encode objects, use
# JSON.encode(object)
# -This will return a string with JSON. Object can be any one of the following
#  -Integer
#  -String
#  -Boolean
#  -Hash
#  -Array
#  -Nil
#
# Credits:
# game_guy ~ Creating it.
#===============================================================================
module JSON
  
  TOKEN_NONE = 0;
  TOKEN_CURLY_OPEN = 1;
  TOKEN_CURLY_CLOSED = 2;
  TOKEN_SQUARED_OPEN = 3;
  TOKEN_SQUARED_CLOSED = 4;
  TOKEN_COLON = 5;
  TOKEN_COMMA = 6;
  TOKEN_STRING = 7;
  TOKEN_NUMBER = 8;
  TOKEN_TRUE = 9;
  TOKEN_FALSE = 10;
  TOKEN_NULL = 11;
  
  @index = 0
  @json = ""
  @length = 0
  
  def self.decode(json)
    @json = json
    @index = 0
    @length = @json.length
    return self.parse
  end
  
  def self.encode(obj)
    if obj.is_a?(Hash)
      return self.encode_hash(obj)
    elsif obj.is_a?(Array)
      return self.encode_array(obj)
    elsif obj.is_a?(Fixnum) || obj.is_a?(Float)
      return self.encode_integer(obj)
    elsif obj.is_a?(String)
      return self.encode_string(obj)
    elsif obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
      return self.encode_bool(obj)
    elsif obj.is_a?(NilClass)
      return "null"
    end
    return nil
  end
  
  def self.encode_hash(hash)
    string = "{"
    hash.each_key {|key|
      string += "\"#{key}\":" + self.encode(hash[key]).to_s + ","
    }
    string[string.size - 1, 1] = "}"
    return string
  end
  
  def self.encode_array(array)
    string = "["
    array.each {|i|
      string += self.encode(i).to_s + ","
    }
    string[string.size - 1, 1] = "]"
    return string
  end
  
  def self.encode_string(string)
    return "\"#{string}\""
  end
  
  def self.encode_integer(int)
    return int.to_s
  end
  
  def self.encode_bool(bool)
    return (bool.is_a?(TrueClass) ? "true" : "false")
  end
  
  def self.next_token(debug = 0)
    char = @json[@index, 1]
    @index += 1
    case char
    when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-' 
      return TOKEN_NUMBER
    when '{' 
      return TOKEN_CURLY_OPEN
    when '}' 
      return TOKEN_CURLY_CLOSED
    when '"' 
      return TOKEN_STRING
    when ',' 
      return TOKEN_COMMA
    when '['
      return TOKEN_SQUARED_OPEN
    when ']'
      return TOKEN_SQUARED_CLOSED
    when ':' 
      return TOKEN_COLON
    end
    @index -= 1
    if @json[@index, 5] == "false"
      @index += 5
      return TOKEN_FALSE
    elsif @json[@index, 4] == "true"
      @index += 4
      return TOKEN_TRUE
    elsif @json[@index, 4] == "null"
      @index += 4
      return TOKEN_NULL
    end
    return TOKEN_NONE
  end
  
  def self.parse(debug = 0)
    complete = false
    while !complete
      if @index >= @length
        break
      end
      token = self.next_token
      case token
      when TOKEN_NONE
        return nil
      when TOKEN_NUMBER
        return self.parse_number
      when TOKEN_CURLY_OPEN
        return self.parse_object
      when TOKEN_STRING
        return self.parse_string
      when TOKEN_SQUARED_OPEN
        return self.parse_array
      when TOKEN_TRUE
        return true
      when TOKEN_FALSE
        return false
      when TOKEN_NULL
        return nil
      end
    end
  end
  
  def self.parse_object
    obj = {}
    complete = false
    while !complete
      token = self.next_token
      if token == TOKEN_CURLY_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        name = self.parse_string
        return nil if name == nil
        token = self.next_token
        return nil if token != TOKEN_COLON
        value = self.parse
        obj[name] = value
      end
    end
    return obj
  end
  
  def self.parse_string
    complete = false
    string = ""
    prevchar = ""
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      if char == '"' and prevchar != "\\"
        complete = true
        break
      else
        string += char.to_s
        prevchar = char.to_s
      end
    end
    if !complete
      return nil
    end
    return string
  end
  
  def self.parse_number
    @index -= 1
    negative = @json[@index, 1] == "-" ? true : false
    string = ""
    complete = false
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when "{", "}", ":", ",", "[", "]"
        @index -= 1
        complete = true
        break
      when "0", "1", "2", '3', '4', '5', '6', '7', '8', '9'
        string += char.to_s
      end
    end
    return string.to_i
  end
  
  def self.parse_array
    obj = []
    complete = false
    while !complete
      token = self.next_token(1)
      if token == TOKEN_SQUARED_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        @index -= 1
        value = self.parse
        obj.push(value)
      end
    end
    return obj
  end
  
end
=begin
class Window_TextEdit < Window_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :name                     # name
  attr_reader   :index                    # cursor position
  attr_reader   :max_char                 # maximum number of characters
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(text, max_char)
    x = (Graphics.width - 360) / 2
    y = (Graphics.height - (fitting_height(4) + fitting_height(9) + 8)) / 2
    super(x, y, 360, fitting_height(4))
    @text = text
    @default_name = ""
    @name = ""
    @max_char = max_char
    @index = @name.size
    deactivate
    refresh
  end
  #--------------------------------------------------------------------------
  # * Revert to Default Name
  #--------------------------------------------------------------------------
  def restore_default
    @name = @default_name
    @index = @name.size
    refresh
    return !@name.empty?
  end
  #--------------------------------------------------------------------------
  # * Add Text Character
  #     ch : character to add
  #--------------------------------------------------------------------------
  def add(ch)
    return false if @index >= @max_char
    @name += ch
    @index += 1
    refresh
    return true
  end
  #--------------------------------------------------------------------------
  # * Go Back One Character
  #--------------------------------------------------------------------------
  def back
    return false if @index == 0
    @index -= 1
    @name = @name[0, @index]
    refresh
    return true
  end
  #--------------------------------------------------------------------------
  # * Get Character Width
  #--------------------------------------------------------------------------
  def char_width
    text_size($game_system.japanese? ? "?" : "A").width 
  end
  #--------------------------------------------------------------------------
  # * Get Coordinates of Left Side for Drawing Name
  #--------------------------------------------------------------------------
  def left
    name_center = contents_width / 2
    name_width = (@max_char + 1) * char_width
    return [name_center - name_width / 2, contents_width - name_width].min
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Item
  #--------------------------------------------------------------------------
  def item_rect(index)
    Rect.new(left + index * char_width, 36, char_width, line_height)
  end
  #--------------------------------------------------------------------------
  # * Get Underline Rectangle
  #--------------------------------------------------------------------------
  def underline_rect(index)
    rect = item_rect(index)
    rect.x += 1
    rect.y += rect.height
    rect.width -= 2
    rect.height = 2
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Underline Color
  #--------------------------------------------------------------------------
  def underline_color
    color = normal_color
    color.alpha = 48
    color
  end
  #--------------------------------------------------------------------------
  # * Draw Underline
  #--------------------------------------------------------------------------
  def draw_underline(index)
    contents.fill_rect(underline_rect(index), underline_color)
  end
  #--------------------------------------------------------------------------
  # * Draw Text
  #--------------------------------------------------------------------------
  def draw_char(index)
    rect = item_rect(index)
    rect.x -= 1
    rect.width += 4
    change_color(normal_color)
    draw_text(rect, @name[index] || "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def draw_title
    draw_text(0, 10, self.width, line_height, @text, 1)
  end
  
  def refresh
    contents.clear
    draw_title
    @name.size.times {|i| draw_char(i) }
    @max_char.times {|i| draw_underline(i) }
    cursor_rect.set(item_rect(@index))
  end
end
class Window_TextInput < Window_NameInput
  def on_name_ok
    Sound.play_ok
    call_ok_handler
  end
end
class Game_Interpreter
  def enter_text(text="", var=Tsuki::Text_Input::Text_Variable, max_char=Tsuki::Text_Input::Max_Chars)
    SceneManager.call(Scene_Text)
    SceneManager.scene.prepare(text, var, max_char)
    Fiber.yield while SceneManager.scene_is?(Scene_Text)
  end
end
=end
# Please note that this has been modified slightly (it didn't work otherwise)
=begin
 Game Custom Data v1.25
 by AdiktuzMiko
 --- Date Created: 11/25/2013
 --- Last Date Updated: 10/09/2014
 --- Level: Easy
 
 This is a simple script which provides you with the capability of having custom data
 for your game that is saved outside of the save files. Since it is outside of save 
 files, it is shared by all. You can even make multiple games share a single custom
 data file.
 
 You can utilize this for having persistent data between your game/games.
 
 You can specify where to put the custom data file, what name will it have and even
 what file extension. 
 
==============================================================================
   ++ Installation ++
==============================================================================
 Install this script in the Materials section in your project's
 script editor.
 
 Modify the ADIK::DATA module to your liking
 
==============================================================================
   ++ Script Calls ++
==============================================================================
 
 CustomData.get(key) to get a certain value
 CustomData.set(key,value) to set the value saved in "key" equal to "value"
 CustomData.add(key,value) to add value to the current value of the data
 CustomData.sub(key,value) to subtract value to the current value of the data
 CustomData.mul(key,value) to multiply the current value of the data by the given value
 CustomData.div(key,value) to divide the current value of the data by the given value
 CustomData.push(key,value) to add the given value into an array saved as custom data
 CustomData.delete(key,value) to remove the given value from an array saved as custom data
 CustomData.save to save the current contents of custom data
 
 Note: Custom Data is loaded automatically upon running the game
 
==============================================================================
   ++ Compatibility ++
==============================================================================
 This script aliases the following default VXA methods:
   DataManager#load_database
	 DataManager#load_game
	 Scene_Title#start
     DataManager#save_game_without_rescue
==============================================================================
   ++ Terms and Conditions ++
==============================================================================
 Read this: http://lescripts.wordpress.com/terms-and-conditions/
==============================================================================
 
=end
module ADIK
  module DATA
  
  # Primary folder where the save data will be placed
  # based on the default paths in your computer
  # set to nil if you don't want to use this
  DATA_PATH = 'CURRENT'
	
#~ 	Heres a list of parameters you can set the DATA_PATH into
#~ 	
#~ 	AppData = Contains the full path to the Application Data directory of the logged-in user
#~ 	LOCALAPPDATA = This variable is the temporary files of Applications.
#~      CURRENT = Folder where the game is run from
#~ 	!!!The following might require your game to run in admin mode!!!
#~ 	ProgramFiles = This variable points to Program Files directory
#~ 	CommonProgramFiles = This variable points to Common Files directory
    
  #Enter each subfolder paths after the primary folder here
  #The script automatically creates the folder path specified
  FOLDER = ["RPGMaker_GameJolt_API"]
	 
  #File name of the custom data file, include file extension
  FILENAME = "gjdata.data"
	#Does the system save the custom data every time that you change it
	AUTOSAVE = true
  #On this example settings given, the file will be saved into
  #C:\Users\USER\AppData\Roaming\RPGMaker\Games\Data.rvdata2
  end
end
#==============================================================================
# DO NOT EDIT BELOW THIS LINE
#==============================================================================
module DataManager
  
  class <<self; alias load_database_customdata load_database; end
  def self.load_database
    load_database_customdata 
    if not ADIK::DATA::DATA_PATH == 'CURRENT'
      @spath = ENV[ADIK::DATA::DATA_PATH] + "\\"
    else
      @spath = ""
    end
    ADIK::DATA::FOLDER.each do |path|
      @spath += path + "\\"
      self.ensure_file_exist(@spath)
    end
    @path = @spath + ADIK::DATA::FILENAME
    begin
      load_customdata
    rescue
      $adik_custom_data = {}
      save_customdata
    end
  end
  
  # tag: modified
  class <<self; alias load_game_customdata load_game; end
  def self.load_game(index)
    re = load_game_customdata(index)
    if re
      load_customdata unless ADIK::DATA::AUTOSAVE
      return re
    else
      return false
    end
  end
  
  def self.customdata_filename
    return  @path
  end
  
  def self.customdata_file_exists?
    FileTest.exist?(customdata_filename) 
  end
  
  class <<self; alias save_game_without_rescue_customdata save_game_without_rescue; end
  def self.save_game_without_rescue(index)
    save_game_without_rescue_customdata(index)
    DataManager.save_customdata
    return true
  end
  
  def self.load_customdata
    File.open(customdata_filename, "rb") do |file|
      contents = Marshal.load(file)
      $adik_custom_data = contents[:adik_custom_data]
    end
    return true
  end
  
  def self.save_customdata
    File.open(customdata_filename, "wb") do |file|
      contents = {}
      contents[:adik_custom_data] = $adik_custom_data
      Marshal.dump(contents, file)
    end
    return true
  end
  
end
module CustomData
  def self.get(key)
    return $adik_custom_data[key]
  end
  
  def self.set(key,value)
    $adik_custom_data[key] = value
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.save
  	DataManager.save_customdata
  end
  
  def self.add(key,value)
    $adik_custom_data[key] += value
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.sub(key,value)
    $adik_custom_data[key] -= value
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.mul(key,value)
    $adik_custom_data[key] *= value
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.div(key,value)
    $adik_custom_data[key] /= value
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.push(key,value)
  	$adik_custom_data[key] = [] if $adik_custom_data[key].nil?
    $adik_custom_data[key].push(value)
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
  def self.delete(key,value)
    $adik_custom_data[key].delete(value)
	DataManager.save_customdata if ADIK::DATA::AUTOSAVE
  end
  
end
class Scene_Title
  alias custom_data_start start
  def start
   custom_data_start
   DataManager.load_customdata unless ADIK::DATA::AUTOSAVE
 end
end
#GameJolt API for RPG Maker VX Ace
module GameJolt
  # Functions
  def self.login()
    user_name = Scene_Text.read("What's your username?", "center", 20)
    user_name.gsub!("&", "_")
    user_token = Scene_Text.read("What's your user token?", "center", 20)
    user_token.gsub!("&", "_")
    
    isCorrect = authenticate(user_name, user_token)
    
    if isCorrect
      CustomData.set("gj_username", user_name)
      CustomData.set("gj_usertoken", user_token)
      sync_trophies()
    end
    
    return isCorrect
  end
  def self.is_logged_in()
    # This will re-authenticate if logged in, so don't call it all the time.
    user_name = CustomData.get("gj_username")
    user_token = CustomData.get("gj_usertoken")
    if user_name != nil and user_token != nil
      return authenticate(user_name, user_token)
    else
      return false
    end
  end
  
  def self.award_trophy(trophy_id)
    local_trophies = CustomData.get("trophies")
    if local_trophies == nil
      trophy_has_local = false
    else
      trophy_has_local = local_trophies.include?(trophy_id)
    end
    unless trophy_has_local
      CustomData.push("trophies", trophy_id)
    end
    if has_login_data and ((not trophy_has_local) or (not CustomData.get("isTrophySynced")))
      sync_trophies()
    end
  end
  
  def self.submit_score(score, score_description = "(SCORE) point(SCOREPLURAL)", scoreboard_id = "main", extra_data = "", allow_guests = false, guest_name = "")
    isloggedin = is_logged_in()
    parameterstring = "?score=" + score_description.gsub("(SCORE)", score.to_s)
    if score != 1
      parameterstring.gsub!("(SCOREPLURAL)", "s")
    else
      parameterstring.gsub!("(SCOREPLURAL)", "")
    end
    parameterstring += "&sort=" + score.to_s
    if scoreboard_id != "main"
      parameterstring += "&table_id=" + scoreboard_id
    end
    if extra_data != ""
      parameterstring += "&extra_data=" + extra_data
    end
    if isloggedin
      return do_request("scores/add/" + parameterstring + "&" + get_userdata_string())
    else
      if allow_guests
        if guest_name == ""
          enter_text("Please enter your name to submit your score:", -1, 15)
          guest_name = $inputText
          guest_name.gsub!("&", "_")
        end
        if guest_name == ""
          return false
        else
          return do_request("scores/add/" + parameterstring + "&guest=" + guest_name)
        end
      end
      return false
    end
  end
  
  def self.show_highscores(numberofscores = 4, scoreboard_id = "main")
    $game_message.add(get_highscores_formatted(numberofscores, scoreboard_id))
  end
  
  def self.logoff()
    CustomData.set("gj_username", "")
    CustomData.set("gj_usertoken", "")
  end
  
  # Internal vars
  @error = ""
  
  # Internal functions (you can use these if you need, but you'll want to use
  # the functions above most of the time)
  # tag: modified
  def self.do_request(baseUrl)
    urlHash = "http://gamejolt.com/api/game/v1/" + baseUrl + "&game_id=" + GameId + "&format=json"
    urlHash = PONY::API::LoadGamegoltUrl.call(urlHash)
    urlHash = PONY.MD5(urlHash)
    result = EFE.request("gamejolt.com", "api/game/v1/" + baseUrl + "&game_id=" + GameId + "&format=json&signature=" + urlHash)
    result = JSON.decode(result)
    if result != nil
      return result["response"]
    else
      return {"success" => "false"}
    end
  end
  
  def self.make_bool(string)
    return string == "true"
  end
  
  def self.authenticate(username, token)
    request = do_request("users/auth/?username=" + username + "&user_token=" + token)
    success = make_bool(request["success"])
    unless success
      @error = request["message"]
    end
    return success
  end
  
  def self.get_userdata_string()
    user_name = CustomData.get("gj_username")
    user_token = CustomData.get("gj_usertoken")
    return "username=" + user_name + "&user_token=" + user_token
  end
  
  def self.get_error()
    return @error
  end
  
  def self.sync_trophies()
    local_trophies = CustomData.get("trophies")
    if local_trophies != nil
      request = do_request("trophies/?" + get_userdata_string())
      success = make_bool(request["success"])
      if success
        CustomData.set("isTrophySynced", true)
        online_trophies = request["trophies"]
        if online_trophies != ""
          online_trophies.each do |online_trophy|
            trophy_id = online_trophy["id"]
            trophy_has_local = local_trophies.include?(trophy_id)
            trophy_has_online = make_bool(online_trophy["achieved"])
            if trophy_has_local and not trophy_has_online
              do_request("trophies/add-achieved/?" + get_userdata_string() + "&trophy_id=" + trophy_id)
            end
          end
        end
      else
        @error = request["message"]
        CustomData.set("isTrophySynced", false)
      end
    end
  end
  
  def self.get_highscores_formatted(numberofscores = 10, scoreboard_id = "main")
    all_highscores = get_highscores(numberofscores, scoreboard_id)
    if all_highscores != nil and all_highscores != ""
      result = ""
      number = 1
      all_highscores.each do |one_highscore|
        if number != 1
          result += "\n"
        end
        resultpart = (number >= 10 ? "" : " ") + (number >= 100 or numberofscores < 100 ? "" : " ") + number.to_s + ": "
        resultpart += one_highscore["name"]
        scorestring = one_highscore["score"]
        numberofspaces = (52 - scorestring.length - resultpart.length)
        if numberofspaces > 0
          resultpart += ' ' * numberofspaces
        else
          if scorestring.length < 40
            resultpart = resultpart[0...(48 - scorestring.length)] + "... "
          end
        end
        resultpart += scorestring
        result += resultpart
        number += 1
      end
      if result.include?("\\")
        result.gsub!("\\", " ")
      end
      return result
    else
      return ""
    end
  end
  
  def self.get_highscores(numberofscores = 10, scoreboard_id = "main", user_only = false)
    parameterstring = "?limit=" + numberofscores.to_s
    if user_only
      if has_login_data()
        parameterstring += "&" + get_userdata_string()
      end
    end
    if scoreboard_id != "main"
      parameterstring += "&table_id=" + scoreboard_id
    end
    request = do_request("scores/" + parameterstring)
    success = make_bool(request["success"])
    if success
      all_highscores = request["scores"]
      if all_highscores != ""
        all_highscores.each do |one_highscore|
          one_highscore["name"] = (one_highscore["guest"] == "") ? one_highscore["user"] : one_highscore["guest"]
        end
      end
      return all_highscores
    else
      return nil
    end
  end
  
  def self.has_login_data()
    # A quick way to see if there is any chance that the player has logged in.
    # This does not guarantee that the login data is correct (use is_logged_in()
    # for that), but it does guarantee that an username and password have been
    # supplied.
    user_name = CustomData.get("gj_username")
    user_token = CustomData.get("gj_usertoken")
    return (user_name != nil and user_token != nil)
  end
  
  # Copied this to here.
  def self.enter_text(text="", var=Tsuki::Text_Input::Text_Variable, max_char=Tsuki::Text_Input::Max_Chars)
    SceneManager.call(Scene_Text)
    SceneManager.scene.prepare(text, var, max_char)
    Fiber.yield while SceneManager.scene_is?(Scene_Text)
  end
end
