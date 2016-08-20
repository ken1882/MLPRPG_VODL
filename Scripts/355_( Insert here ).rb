=begin


* To users of scripts

 * When using scripts obtained through online websites,
  create a new section at this position and paste the script here.
  (Select "Insert" from the pop-up menu in the left list box.)

 * If the creator of the script has any other special instructions, follow them.

 * In general, RPG Maker VX and RPG Maker XP scripts are not compatible, 
   so make sure the resources you have are for RPG Maker VX Ace 
   before you use them.


* To authors of scripts

 * When developing scripts to be distributed to the general public,
  we recommend that you use redefinitions and aliases as much as
  possible, to allow the script to run just by pasting it in this position.


=end
#==============================================================================
# 
# ▼ Yanfly Engine Ace - JP Manager v1.00
# -- Last Updated: 2012.01.07
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-JPManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.07 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script provides a base for JP implementation. JP is a currency similar
# to EXP that's gained through performing actions and leveling up in addition
# to killing enemies. This script provides modifiers that adjust the gains for
# JP through rates, individual gains per skill or item, and per enemy. Though
# this script provides no usage of JP by itself, future Yanfly Engine Ace
# scripts may make use of it.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# When the actor successfully hits an target with this action, the actor will
# earn x JP. If this notetag isn't used, the amount of JP earned will equal to
# the ACTION_JP constant in the module.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# When the actor successfully hits an target with this action, the actor will
# earn x JP. If this notetag isn't used, the amount of JP earned will equal to
# the ACTION_JP constant in the module.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapon notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# Changes the amount of JP gained for killing the enemy to x. If this notetag
# isn't used, then the default JP gain will be equal to the amount set in the
# module through the constant ENEMY_KILL.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# $game_actors[x].earn_jp(y)
# $game_actors[x].earn_jp(y, z)
# This will cause actor x to earn y amount of JP. JP earned will be modified by
# any JP Rate traits provided through notetags. If z is used, z will be the
# class the JP is earned for.
# 
# $game_actors[x].gain_jp(y)
# $game_actors[x].gain_jp(y, z)
# This will cause actor x to gain y amount of JP. JP gained this way will not
# be modified by any JP Rate traits provided through notetags. If z is used,
# z will be the class the JP is gained for.
# 
# $game_actors[x].lose_jp(y)
# $game_actors[x].lose_jp(y, z)
# This will cause actor x to lose y amount of JP. JP lost this way will not be
# modified by any JP Rate traits provided through notetags. If z is used, z
# will be the class the JP is lost from.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - Victory Aftermath v1.03+.
# If you wish to have Victory Aftermath display JP gains, make sure the version
# is 1.03+. Script placement of these two scripts don't matter.
# 
#==============================================================================

