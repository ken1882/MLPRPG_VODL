#============================================================================
# Zerbu Engine - Extra Starting Position Option
#----------------------------------------------------------------------------
# This script adds an extra "New Game" type option to the menu that allows you
# to specify a different starting location. This is good for creating
# playable tutorials.
#============================================================================

#============================================================================
# (module) ZE_Extra_Starting_Position_Option
#============================================================================
module ZE_Extra_Starting_Position_Option
  ZE_ESPO = {
	#------------------------------------------------------------------------
	# Options
	#------------------------------------------------------------------------
	# This is the text that will appear on the title screen.
	#------------------------------------------------------------------------
	:NAME => "Credits",
	#------------------------------------------------------------------------
	# This is the number for the map the player should start on when the
	# extra option is selected.
	#------------------------------------------------------------------------
	:MAP => 23,
	#------------------------------------------------------------------------
	# This is the X and Y position the player should start at when the
	# extra option is selected.
	#------------------------------------------------------------------------
	:MAP_X => 1,
	:MAP_Y => 1,
  }
end

#============================================================================
# Window_TitleCommand
#============================================================================
class Window_TitleCommand
  include ZE_Extra_Starting_Position_Option
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias ze_espo_make_command_list make_command_list
  def make_command_list
	#---
	ze_espo_make_command_list
	add_command(ZE_ESPO[:NAME], :espo)
	#---
  end
end

#============================================================================
# Scene_Title
#============================================================================
class Scene_Title
  include ZE_Extra_Starting_Position_Option
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias ze_espo_create_command_window create_command_window
  def create_command_window
	#---
	ze_espo_create_command_window
	@command_window.set_handler(:espo, method(:command_espo))
	#---
  end

  #--------------------------------------------------------------------------
  # new method: command_espo
  #--------------------------------------------------------------------------
  def command_espo
	#---
	DataManager.create_game_objects
	#---
	$game_party.setup_starting_members
	#---
	$game_map.setup(ZE_ESPO[:MAP])
	#---
	$game_player.moveto(ZE_ESPO[:MAP_X], ZE_ESPO[:MAP_Y])
	$game_player.refresh
	#---
	Graphics.frame_count = 0
	#---
	close_command_window
	fadeout_all
	#---
	$game_map.autoplay
	#---
	SceneManager.goto(Scene_Map)
	#---
  end
end