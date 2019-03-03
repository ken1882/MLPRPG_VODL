=begin
#===============================================================================
 Title: External Script Loader
 Author: Tsukihime
 Date: Dec 2, 2013
 URL: http://himeworks.wordpress.com/2013/12/02/external-script-loader/
--------------------------------------------------------------------------------
 ** Change log
 Dec 2, 2013
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in commercial/non-commercial projects
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Tsukihime in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script allows you to load external scripts into the game. It supports
 loading from encrypted archives as well.

--------------------------------------------------------------------------------
 ** Installation
 
 Place this script below Materials and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 To load and evaluate script, use the following function call:
 
   load_script(script_path)
   
--------------------------------------------------------------------------------
 ** Example
 
 I have a folder called "Scripts" and a script called "test.rb" in that folder.
 If I want to load the script, I would just write
 
   load_script("Scripts/test.rb")
   
 This will evaluate the test script.
 
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported["TH_ExternalScriptLoader"] = true
#===============================================================================
# * Rest of Script
#===============================================================================
#-------------------------------------------------------------------------------
# Convenience function. Equivalent to
#   script = load_data(path)
#   eval(script)
# It supports loading from encrypted archives
#-------------------------------------------------------------------------------
def load_script(path)
  loader_eval(load_data(path))
end

#-------------------------------------------------------------------------------
# Load files from non-RM files
#-------------------------------------------------------------------------------
class << Marshal
  alias_method(:th_core_load, :load)
  def load(port, proc = nil)
    th_core_load(port, proc)
  rescue TypeError
    if port.kind_of?(File)
      port.rewind 
      port.read
    else
      port
    end
  end
end unless Marshal.respond_to?(:th_core_load)