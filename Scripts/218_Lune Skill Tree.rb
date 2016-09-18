#tag: skill tree
#=======================================================
#         Lune Unlimited Skill Tree
# Author: Raizen
# Comunitty: www.centrorpg.com
# Classic Skill Tree, used in many RPG Games, like
# Diablo, Ragnarok... And many others
#=======================================================
module COMP
  POINT_TABLE = [
    3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,70,77,84,91,99
#   1,2, 3, 4, 5, 6, 7, 8 ,9,10,11,12,13,14,15,16,17,18,19,20,21    
  ]
end
#=======================================================
# Don't modify!!
#=======================================================
$imported = {} if $imported == nil
$imported[:Lune_Skill_Tree] = true
module Lune_Skill_Tree
$data_actors = load_data("Data/Actors.rvdata2")
Actor = Array.new($data_actors.size) {Array.new}
MENU_SKILLTREE_TERM = "Talent Tree"
#=======================================================
#         Image and basic Settings
#=======================================================
# Add a skill point when leveling?
Add_Skill_pt = true
# To add points manually, just
# Script: add_tree_points(actor_id, points)
# actor_id is the id of the actor, points the quantity.
# Name of cursor image
Cursor = "cursor"
# X axis correction of the cursor position
Cursor_X = -20
# Y axis correction of the cursor position
Cursor_Y = 0
# Image for character selection
# Default size of image for Ace is 384x416, if you do not wish
# an extra image put '' on image name.
Actor_Select = 'actor_select'
#=======================================================
#         Windows and font configuration
#=======================================================
# Size of description window
Win_Size = 100
# Window Opacity, if images are used, put 0
Opacity = 0
# Size of Skill font
Font_Skills = 16
# Size of Description font
Font_Help = 22
# Font Name, put '' to get the default font.
Font_Name = "" 
# Correction of skill info position.
Corr_X = -10
Corr_Y = 20
# Position of the text of the total points
Text_Y = 250
Text_X = 330
Text_Y2 = 280
Text_X2 = 330
# Texto
Text = 'Total Points: '
Text2 = 'JP: '
# Text on Option Window
#Bot1 = 'Use'
Bot2 = 'Add Point'
Bot3 = 'Cancel'
#=========================================================================
# Actor 1 => TS Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[1][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['TS', 'TS', 'TS', 'TS',],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[400, 50], [400, 80], [400, 110], [400, 140]],
}
#=========================================================================
# Actor 2 => AJ Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[2][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['AJ', 'AJ2', 'AJ3'],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[420, 65], [400, 100], [410, 135]],
}
#=========================================================================
# Actor 4 => PP Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[4][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['PP', 'PP', 'PP', 'PP',],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[400, 50], [400, 80], [400, 110], [400, 140]],
}
#=========================================================================
# Actor 5 => RD Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[5][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['RD', 'RD2', 'RD3'],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[420, 55], [410, 85], [435, 115]],
}
#=========================================================================
# Actor 6 => RR Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[6][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['RR', 'RR', 'RR', 'RR',],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[400, 50], [400, 80], [400, 110], [400, 140]],
}
#=========================================================================
# Actor 7 => FS Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
Actor[7][0] = {
# Images of the skill trees, put as many as wanted
# if you do not wish to have images, put '' on the name place
'Tree_Images' => ['FS', 'FS', 'FS', 'FS',],
# Position of the cursors that change between the trees.
'Tree_Shift' => [[400, 50], [400, 80], [400, 110], [400, 140]],
}
#=========================================================================
# TAG : TS
# Actor 1 => TS Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
#==========================================================================
#   Primal 1 ~ 16
#==========================================================================
Actor[1][1] = {
'Skill_id' =>563, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Flame Blast(JP cost: 300)', # Description 1
'Desc2' => ' Inflicting fire damage on all targets in the area.', # Description 2
'Desc3' => ' Casue fire damage in (120-0 , 5-5) rectangle', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[1][2] = {
'Skill_id' => 564, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [563], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Flaming Bless (JP cost: 1000)', # Description 1
'Desc2' => " Boost all allies' flame resist, ", # Description 2
'Desc3' => ' normal attack have flame attack bonus, double fire damage.', # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[1][3] = {
'Skill_id' =>565, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [564], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Fireball (JP cost: 2000)', # Description 1
'Desc2' => ' Inflicting fire damgage in AOE + knockback.', # Description 2
'Desc3' => " AOE:(120-120 , 120-50), target's AT drop to zero.", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[1][4] = {
'Skill_id' =>566, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [565], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Inferno (JP cost: 3800)', # Description 1
'Desc2' => ' The caster summons a huge column of swirling flame.', # Description 2
'Desc3' => 'For 5 turns, enemies suffer from fire in every end of turn. ', # Description 3
'JP' => 3800,
}
#====================================================
#
#====================================================
Actor[1][5] = {
'Skill_id' =>568, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rock Armor (JP cost: 300)', # Description 1
'Desc2' => " Caster's skin is as hard as stone.", # Description 2
'Desc3' => " Double caster's DEF and resist half earth and physical damage.", # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[1][6] = {
'Skill_id' =>569, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [568], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Stonefist (JP cost: 1000)', # Description 1
'Desc2' => "Hurls a stone projectile that knocks down the target.", # Description 2
'Desc3' => "If target is petrified or frozen, dealing massive earth damage.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[1][7] = {
'Skill_id' =>570, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [569], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Earthquake (JP cost: 2000)', # Description 1
'Desc2' => "Causing a violent quake, last for 4 turns. Knockback all foes", # Description 2
'Desc3' => "in every end of turn unless they pass the saving throw.", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[1][8] = {
'Skill_id' =>572, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [570], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Petrify (JP cost: 4000)', # Description 1
'Desc2' => "Turn a target into a stone unless pass the saving throw.", # Description 2
'Desc3' => "Petrified will last forever unless somepony rescue him/her.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[1][9] = {
'Skill_id' =>573, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Winter Grasp (JP cost: 300)', # Description 1
'Desc2' => "The caster envelops the target in frost.", # Description 2
'Desc3' => "Chill target, if it have been chilled then frozen.", # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[1][10] = {
'Skill_id' =>574, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [573], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Frost Bless (JP cost: 1000)', # Description 1
'Desc2' => "Boost all allies' ice resist", # Description 2
'Desc3' => "normal attack have ice attack bonus, 1.5x ice damage.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[1][11] = {
'Skill_id' =>575, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [574], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Cone of Cold (JP cost: 2300)', # Description 1
'Desc2' => "Erupts with a cone of frost, damaging foes in AOE,", # Description 2
'Desc3' => "freezing targets unless they pass the saving throw.", # Description 3
'JP' => 2300,
}
#====================================================
#
#====================================================
Actor[1][12] = {
'Skill_id' =>576, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [575], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Blizzard (JP cost: 4000)', # Description 1
'Desc2' => "For 5 turns,an ice storm deals continuous cold damage.", # Description 2
'Desc3' => "Slows foe's movement speed every end of turn.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[1][13] = {
'Skill_id' =>578, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Lighting Bolt (JP cost: 400)', # Description 1
'Desc2' => "Caster fires a bolt of lighting at the target.", # Description 2
'Desc3' => "Dealing thunder damage.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[1][14] = {
'Skill_id' =>579, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [578], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shock (JP cost: 1100)', # Description 1
'Desc2' => "The caster's hoof erupt, emitting a cone of lightning.", # Description 2
'Desc3' => "Damaging all targets in the area. ", # Description 3
'JP' => 1100,
}
#====================================================
#
#====================================================
Actor[1][15] = {
'Skill_id' =>580, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [579], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Tempeset (JP cost: 2400)', # Description 1
'Desc2' => "The caster unleashes a fierce lightning storm. For 5 turns, ",
'Desc3' => "all foes take thunder damage in every end of turn.",
'JP' => 2400,
}
#====================================================
#
#====================================================
Actor[1][16] = {
'Skill_id' =>582, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [580], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Chain Lighting (JP cost: 5000)', # Description 1
'Desc2' => "Emitting a bolt of lightning on a target, then forks,", # Description 2
'Desc3' => "sending smaller bolts jumping to those nearby, which fork again.", # Description 3
'JP' => 5000,
}
#==============================================================================
#
#     17 ~ 32 : Spirit
#
#==============================================================================
#====================================================
#
#====================================================
Actor[1][17] = {
'Skill_id' =>584, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 29, # Skill to the left, 0 for none
'Right' => 21, # Skill to the right, 0 for none
'Down' => 18, # Skill below, 0 for none
'Up' => 20, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Spell Shield (JP cost: 350)(Event Required)', # Description 1
'Desc2' => 'While actived, all upcoming magical attacks will be absorbed, consuming', # Description 2
'Desc3' => 'EP instead. The shield collapses once you out of EP.', # Description 3
'JP' => 350,
'event' => "spirit_unlocked",
}
#====================================================
#
#====================================================
Actor[1][18] = {
'Skill_id' => 585, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 30, # Skill to the left, 0 for none
'Right' => 22, # Skill to the right, 0 for none
'Down' => 19, # Skill below, 0 for none
'Up' => 17, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [584], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Dispel Magic (JP cost: 1000)', # Description 1
'Desc2' => 'Pony removes all dispellable effects from the target.', # Description 2
'Desc3' => 'Friendly fire possible.', # Description 3
'JP' => 1000,
}
#====================================================
#
#==============================5======================
Actor[1][19] = {
'Skill_id' =>586, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 31, # Skill to the left, 0 for none
'Right' => 23, # Skill to the right, 0 for none
'Down' => 20, # Skill below, 0 for none
'Up' => 18, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [585], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Anti-Magic Ward(JP cost: 2000)', # Description 1
'Desc2' => 'Pony wards an ally against all magical effects or damage.',
'Desc3' => 'No matter its beneficial or hostile.',
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[1][20] = {
'Skill_id' =>587, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 32, # Skill to the left, 0 for none
'Right' => 24, # Skill to the right, 0 for none
'Down' => 17, # Skill below, 0 for none
'Up' => 19, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [586], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Anti-Magical Brust (JP cost: 3800)', # Description 1
'Desc2' => 'Pony unleash an energy shockwave eliminates all dispellable',
'Desc3' => "magic effects on the battlefield. And interrupt enemy's casting.",
 'JP' => 3800,
}
#====================================================
#
#====================================================
Actor[1][21] = {
'Skill_id' =>588, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 17, # Skill to the left, 0 for none
'Right' => 25, # Skill to the right, 0 for none
'Down' => 22, # Skill below, 0 for none
'Up' => 24, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Energy Drain (JP cost: 320)(Event Required)', # Description 1
'Desc2' => "Pony creates a parasitic bond with a spellcasting target,",
'Desc3' => "absorbing a small amount of mana from it.",
'JP' => 320,
'event' => "spirit_unlocked",
}
#====================================================
#
#====================================================
Actor[1][22] = {
'Skill_id' =>589, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 18, # Skill to the left, 0 for none
'Right' => 26, # Skill to the right, 0 for none
'Down' => 23, # Skill below, 0 for none
'Up' => 21, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [588], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Energy Cleanse (JP cost: 1400)', # Description 1
'Desc2' => "Pony sacrifices some personal EP to damage all enemies EP.",
'Desc3' => "EP Damage based on your Specialty(MAT).",
'JP' => 1400,
}
#====================================================
#
#====================================================
Actor[1][23] = {
'Skill_id' =>590, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 19, # Skill to the left, 0 for none
'Right' => 27, # Skill to the right, 0 for none
'Down' => 24, # Skill below, 0 for none
'Up' => 22, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [589], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Spell Might (JP cost: 2600)', # Description 1
'Desc2' => "While this mode actived, Pony overflows with magical energy. Magical",
'Desc3' => "attack deals 20% more damage but suffer a penatly to EP regeneration.",
'JP' => 2600,
}
#====================================================
#
#====================================================
Actor[1][24] = {
'Skill_id' =>591, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 20, # Skill to the left, 0 for none
'Right' => 28, # Skill to the right, 0 for none
'Down' => 21, # Skill below, 0 for none
'Up' => 23, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [590], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Energy Clash (JP cost: 4500)', # Description 1
'Desc2' => "Pony expels a large energy flow toward enemies, who are completely drained",
'Desc3' => "of EP and simultaneously lose HP proportional to the amount of EP they lost.",
 'JP' => 4500,
}
#====================================================
#
#====================================================
Actor[1][25] = {
'Skill_id' =>592, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 21, # Skill to the left, 0 for none
'Right' => 29, # Skill to the right, 0 for none
'Down' => 26, # Skill below, 0 for none
'Up' => 28, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Fulminant Venom (JP cost: 700)', # Description 1
'Desc2' => "Poison a target that inflicts continual damage. If target dies while",
'Desc3' => "this effect still active, it explodes, damaging all targets nearby.",
'JP' => 700,
}
#====================================================
#
#====================================================
Actor[1][26] = {
'Skill_id' =>593, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 22, # Skill to the left, 0 for none
'Right' => 30, # Skill to the right, 0 for none
'Down' => 27, # Skill below, 0 for none
'Up' => 25, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [592], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Death Syphon (JP cost: 1620)', # Description 1
'Desc2' => "While this mode actived, the caster draining residual power from",
'Desc3' => "any dead enemy nearby to restore the caster's EP. (fatigue: 5%)",
'JP' => 1620,
}
#====================================================
#
#====================================================
Actor[1][27] = {
'Skill_id' =>594, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 23, # Skill to the left, 0 for none
'Right' => 31, # Skill to the right, 0 for none
'Down' => 28, # Skill below, 0 for none
'Up' => 26, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [593], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Virulent Bomb (JP cost: 3250)', # Description 1
'Desc2' => "Upgrades 'Fulminant Venom', it turns into AOE and has longer",
'Desc3' => "durations. The end explosion will also infect the posion.",
'JP' => 3250,
}
#====================================================
#
#====================================================
Actor[1][28] = {
'Skill_id' =>595, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 24, # Skill to the left, 0 for none
'Right' => 32, # Skill to the right, 0 for none
'Down' => 25, # Skill below, 0 for none
'Up' => 27, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [594], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Animate Dead (JP cost: 5820)', # Description 1
'Desc2' => "The caster dominate a corpse from a fallen enemy. It will",
'Desc3' => "fight original mates but it's in count of an enemy.",
'JP' => 5820,
}
#====================================================
#
#====================================================
Actor[1][29] = {
'Skill_id' =>596, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 25, # Skill to the left, 0 for none
'Right' => 17, # Skill to the right, 0 for none
'Down' => 30, # Skill below, 0 for none
'Up' => 32, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Mind Blast (JP cost: 400)', # Description 1
'Desc2' => "Caster projects a wave of telekinetic force that stuns enemies.",
'Desc3' => "",
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[1][30] = {
'Skill_id' =>597, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 26, # Skill to the left, 0 for none
'Right' => 18, # Skill to the right, 0 for none
'Down' => 31, # Skill below, 0 for none
'Up' => 29, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [596], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Force Field (JP cost: 1620)', # Description 1
'Desc2' => "Erects a telekinetic barrier around a target, who becomes completely",
'Desc3' => "immune to all damage, but cannot move. Friendly fire possible.",
'JP' => 1620,
}
#====================================================
#
#====================================================
Actor[1][31] = {
'Skill_id' =>598, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 27, # Skill to the left, 0 for none
'Right' => 19, # Skill to the right, 0 for none
'Down' => 32, # Skill below, 0 for none
'Up' => 30, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [597], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Telekinetic Force (JP cost: 2000)', # Description 1
'Desc2' => "Enchant party that increase the critical and hit rate.",
'Desc3' => "The amount increased based on caster's Specialty.",
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[1][32] = {
'Skill_id' =>599, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 28, # Skill to the left, 0 for none
'Right' => 20, # Skill to the right, 0 for none
'Down' => 29, # Skill below, 0 for none
'Up' => 31, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Crushing Prison (JP cost: 5120)', # Description 1
'Desc2' => "Pony encloses a target in a collapsing cage of telekinetic force,",
'Desc3' => "inflicting damage for the duration.",
'JP' => 5120,
}
#=========================================================================
# TAG : AJ
# Actor 2 => AJ Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
#====================================================
# Archery 1~16
#====================================================
Actor[2][1] = {
'Skill_id' =>546, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Shooting Posture (JP cost: 300)', # Description 1
'Desc2' => ' A right pose for pony to control a ranged weapon.', # Description 2
'Desc3' => ' +5% Hit rate', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[2][2] = {
'Skill_id' => 547, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [546], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Aim (JP cost: 800)', # Description 1
'Desc2' => ' Pony carefully place each shot for maximum effect. ', # Description 2
'Desc3' => ' +20% CRI, 300% aiming time.', # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[2][3] = {
'Skill_id' =>548, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [547], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Defensive Fire (JP cost: 1600)', # Description 1
'Desc2' => ' Defensive to the Offensive! ', # Description 2
'Desc3' => ' +25% DEF & MDF, 300% aiming time.', # Description 3
'JP' => 1600,
}
#====================================================
#
#====================================================
Actor[2][4] = {
'Skill_id' =>549, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [548], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Master Archer (JP cost: 3000)', # Description 1
'Desc2' => ' Pony now is expert in archery!', # Description 2
'Desc3' => ' Your archery skills all has unique bonus.', # Description 3
'JP' => 3000,
}
#====================================================
#
#====================================================
Actor[2][5] = {
'Skill_id' =>550, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Pinning Shot (JP cost: 300)', # Description 1
'Desc2' => " A shot to the target's legs disables the foe, pinning the target in place for a turn.", # Description 2
'Desc3' => ' +Tangle for 1 turn', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[2][6] = {
'Skill_id' =>551, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [550], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Crippling Shot (JP cost: 1000)', # Description 1
'Desc2' => "A carefully aimed shot hampers the target's ability.", # Description 2
'Desc3' => " Lower target's ATK,DEF,AGI by 5% ", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[2][7] = {
'Skill_id' =>552, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [551], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Critical Shot (JP cost: 2000)', # Description 1
'Desc2' => "Finding a chink in the target's defenses, and fire toward it.", # Description 2
'Desc3' => "Armor-piercing damage based on user's ATK&AGI", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[2][8] = {
'Skill_id' =>553, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [552], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Arrow of Slaying (JP cost: 4000)', # Description 1
'Desc2' => "Pony generates an deadly hit if this shot finds its target", # Description 2
'Desc3' => "Dealing considerable damage.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[2][9] = {
'Skill_id' =>554, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rapid Shot (JP cost: 350)', # Description 1
'Desc2' => "Speed wins out over power!", # Description 2
'Desc3' => "No aiming time required, but -15% CRI and 5% hit rate.", # Description 3
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[2][10] = {
'Skill_id' =>555, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [554], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shattering Shot (JP cost: 800)', # Description 1
'Desc2' => "Shot open up a weak spot in the target's armor.", # Description 2
'Desc3' => "Greatly lower target's DEF, dealing some damage as well.", # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[2][11] = {
'Skill_id' =>556, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [555], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Suppressing Fire (JP cost: 2250)', # Description 1
'Desc2' => "User's shots ncumbers the target.", # Description 2
'Desc3' => "Normal shots lower target ATK.", # Description 3
'JP' => 2250,
}
#====================================================
#
#====================================================
Actor[2][12] = {
'Skill_id' =>557, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [556], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Scattershot (JP cost: 4200)', # Description 1
'Desc2' => "Shot upon all foes, also stun them for a period.", # Description 2
'Desc3' => "Damage to all enemies, also stun them.", # Description 3
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[2][13] = {
'Skill_id' =>558, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Accuracy (JP cost: 400)', # Description 1
'Desc2' => "User is concentrate on the next hit.", # Description 2
'Desc3' => "User gains hit rate and damage bonus.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[2][14] = {
'Skill_id' =>559, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [558], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Arrow Time (JP cost: 1200)', # Description 1
'Desc2' => "Intense focus slows the archer's perception of time.", # Description 2
'Desc3' => "While aiming, slows others' ATB speed.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[2][15] = {
'Skill_id' =>560, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [559], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Burst Shot (JP cost: 2500)', # Description 1
'Desc2' => "The archer looses a special shaft that explode to dealing fire damage to all foes.",
'Desc3' => "Damage and knockback all foes.",
'JP' => 2500,
}
#====================================================
#
#====================================================
Actor[2][16] = {
'Skill_id' =>561, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Rain of Arrows (JP cost: 5000)', # Description 1
'Desc2' => "Pepper enemies.", # Description 2
'Desc3' => "Damage several random enemies.", # Description 3
'JP' => 5000,
}
#====================================================
#
#   17~32 : Weapon & Shield
#
#====================================================
#====================================================
#
#====================================================
Actor[2][17] = {
'Skill_id' =>584, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 29, # Skill to the left, 0 for none
'Right' => 21, # Skill to the right, 0 for none
'Down' => 18, # Skill below, 0 for none
'Up' => 20, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Bash (JP cost: 280)', # Description 1
'Desc2' => 'Bash a target with shield, dealing normal damage', # Description 2
'Desc3' => 'and knocking the target off its feet.', # Description 3
'JP' => 280,
}
#====================================================
#
#====================================================
Actor[2][18] = {
'Skill_id' => 585, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 30, # Skill to the left, 0 for none
'Right' => 22, # Skill to the right, 0 for none
'Down' => 19, # Skill below, 0 for none
'Up' => 17, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [584], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shield Pummel  (JP cost: 1000)', # Description 1
'Desc2' => 'Follows up an attack with two hit, stun target ', # Description 2
'Desc3' => 'and dealing normal damage with each attack.', # Description 3
'JP' => 1000,
}
#====================================================
#
#==============================5======================
Actor[2][19] = {
'Skill_id' =>586, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 31, # Skill to the left, 0 for none
'Right' => 23, # Skill to the right, 0 for none
'Down' => 20, # Skill below, 0 for none
'Up' => 18, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [585], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Overpower (JP cost: 2000)', # Description 1
'Desc2' => 'Lashes out with the shield three times.',
'Desc3' => 'The last strike is a critical hit and knock the target down.',
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[2][20] = {
'Skill_id' =>587, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 32, # Skill to the left, 0 for none
'Right' => 24, # Skill to the right, 0 for none
'Down' => 17, # Skill below, 0 for none
'Up' => 19, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [586], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Assault  (JP cost: 3800)', # Description 1
'Desc2' => 'Quickly strikes a target four times with more armor-',
'Desc3' => "piercing bonus, and last strike deals more damage.",
 'JP' => 3800,
}
#====================================================
#
#====================================================
Actor[2][21] = {
'Skill_id' =>588, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 17, # Skill to the left, 0 for none
'Right' => 25, # Skill to the right, 0 for none
'Down' => 22, # Skill below, 0 for none
'Up' => 24, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Defense (JP cost: 280)', # Description 1
'Desc2' => "This mode, pony will drops into a defensive stance",
'Desc3' => "that favors the shield. +5% chance block attacks.",
'JP' => 280,
}
#====================================================
#
#====================================================
Actor[2][22] = {
'Skill_id' =>589, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 18, # Skill to the left, 0 for none
'Right' => 26, # Skill to the right, 0 for none
'Down' => 23, # Skill below, 0 for none
'Up' => 21, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [588], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Balance (JP cost: 800)', # Description 1
'Desc2' => "Pony has learned to compensate for the weight of a shield in combat", # Description 2
'Desc3' => "No longer suffers an attack penalty while using Shield Defense.", # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[2][23] = {
'Skill_id' =>590, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 19, # Skill to the left, 0 for none
'Right' => 27, # Skill to the right, 0 for none
'Down' => 24, # Skill below, 0 for none
'Up' => 22, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [589], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Wall (JP cost: 2500)', # Description 1
'Desc2' => "Pony has 50%/20 more chance to block missile/other attack and", # Description 2
'Desc3' => "immune to stun. But greatly lower ATK,AGI and high fatigue.", # Description 3
'JP' => 2500,
}
#====================================================
#
#====================================================
Actor[2][24] = {
'Skill_id' =>591, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 20, # Skill to the left, 0 for none
'Right' => 28, # Skill to the right, 0 for none
'Down' => 21, # Skill below, 0 for none
'Up' => 23, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [590], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Expertise (JP cost: 3600)', # Description 1
'Desc2' => "Pony's experience using a shield in combat has made certain talents", # Description 2
'Desc3' => "more efficient. Also +5% block when equipped a shield.", # Description 3
 'JP' => 3600,
}
#====================================================
#
#====================================================
Actor[2][25] = {
'Skill_id' =>592, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 21, # Skill to the left, 0 for none
'Right' => 29, # Skill to the right, 0 for none
'Down' => 26, # Skill below, 0 for none
'Up' => 28, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Block  (JP cost: 320)', # Description 1
'Desc2' => "Practice fighting with a shield improves the pony's guard", # Description 2
'Desc3' => "When equipped shield, +5% DEF and +2% missile block.", # Description 3
'JP' => 320,
}
#====================================================
#
#====================================================
Actor[2][26] = {
'Skill_id' =>593, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 22, # Skill to the left, 0 for none
'Right' => 30, # Skill to the right, 0 for none
'Down' => 27, # Skill below, 0 for none
'Up' => 25, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [592], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Cover (JP cost: 1020)', # Description 1
'Desc2' => "While in this mode, pony gains more missile block bonus", # Description 2
'Desc3' => "and reduce 5% physical damage when shield is equipped.", # Description 3
'JP' => 1020,
}
#====================================================
#
#====================================================
Actor[2][27] = {
'Skill_id' =>594, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 23, # Skill to the left, 0 for none
'Right' => 31, # Skill to the right, 0 for none
'Down' => 28, # Skill below, 0 for none
'Up' => 26, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [593], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Tactics (JP cost: 2180)', # Description 1
'Desc2' => "Pony is proficient enough with a shield. When a shield is equipped and ", # Description 2
'Desc3' => "encounter a critical damage, cancel the critical if pass the saving throw.", # Description 3
'JP' => 2180,
}
#====================================================
#
#====================================================
Actor[2][28] = {
'Skill_id' =>595, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 24, # Skill to the left, 0 for none
'Right' => 32, # Skill to the right, 0 for none
'Down' => 25, # Skill below, 0 for none
'Up' => 27, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [594], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Mastery (JP cost: 4000)', # Description 1
'Desc2' => "Pony has mastered the use of the shield for both offense and defense", # Description 2
'Desc3' => "Offensive abilities received the additional benefits.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[2][29] = {
'Skill_id' =>596, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 25, # Skill to the left, 0 for none
'Right' => 17, # Skill to the right, 0 for none
'Down' => 30, # Skill below, 0 for none
'Up' => 32, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Juggernaut (JP cost: 400)', # Description 1
'Desc2' => "Gain more TP with each successful attack.",
'Desc3' => "",
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[2][30] = {
'Skill_id' =>597, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 26, # Skill to the left, 0 for none
'Right' => 18, # Skill to the right, 0 for none
'Down' => 31, # Skill below, 0 for none
'Up' => 29, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [596], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Carapace (JP cost: 1500)', # Description 1
'Desc2' => "No attack gets past this shield completely. For a moderate duration,", # Description 2
'Desc3' => "all damage is reduced by a amount based on your con.", # Description 3
'JP' => 1500,
}
#====================================================
#
#====================================================
Actor[2][31] = {
'Skill_id' =>598, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 27, # Skill to the left, 0 for none
'Right' => 19, # Skill to the right, 0 for none
'Down' => 32, # Skill below, 0 for none
'Up' => 30, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [597], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Air of Insolence (JP cost: 1980)', # Description 1
'Desc2' => "Your pony continuously draws the attention of nearby",
'Desc3' => "enemies. Higher targeted rate and provoke who attacks you.",
'JP' => 1980,
}
#====================================================
#
#====================================================
Actor[2][32] = {
'Skill_id' =>599, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 28, # Skill to the left, 0 for none
'Right' => 20, # Skill to the right, 0 for none
'Down' => 29, # Skill below, 0 for none
'Up' => 31, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Bulwark of the Ages (JP cost: 5000)', # Description 1
'Desc2' => "Upgrade the 'Carapace', character immune to first 3 damage,", # Description 2
'Desc3' => "and raise a few chance to block all damages.", # Description 3
'JP' => 5000,
}
#====================================================
#
#   33~48 : Two hoof Weapon
#
#====================================================
#====================================================
#
#====================================================
Actor[2][33] = {
'Skill_id' => 618, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 45, # Skill to the left, 0 for none
'Right' => 37, # Skill to the right, 0 for none
'Down' => 34, # Skill below, 0 for none
'Up' => 36, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Pommel Strike (JP cost: 310)', # Description 1
'Desc2' => 'Instead of going for the fatal attack an enemy expects. Pony',
'Desc3' => "strikes out with weapon's pommel to knock back target.",
'JP' => 310,
}
#====================================================
#
#====================================================
Actor[2][34] = {
'Skill_id' => 619, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 46, # Skill to the left, 0 for none
'Right' => 38, # Skill to the right, 0 for none
'Down' => 35, # Skill below, 0 for none
'Up' => 33, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [618], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Indomitable (JP cost: 1100)', # Description 1
'Desc2' => "Through sheer force of will, pony remains in control on the battlefield.",
'Desc3' => "+2 bouns to saving throws and immune to knockback/stun. (20% fatigue)", # Description 3
'JP' => 1100,
}
#====================================================
#
#==============================5======================
Actor[2][35] = {
'Skill_id' =>620, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 47, # Skill to the left, 0 for none
'Right' => 39, # Skill to the right, 0 for none
'Down' => 36, # Skill below, 0 for none
'Up' => 34, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [619], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Stunning Blow (JP cost: 2000)', # Description 1
'Desc2' => "Pony's fondness for massive two-hoofed weapons means that each normal",
'Desc3' => "attack offers a chance to stun the opponent.",
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[2][36] = {
'Skill_id' =>621, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 48, # Skill to the left, 0 for none
'Right' => 40, # Skill to the right, 0 for none
'Down' => 33, # Skill below, 0 for none
'Up' => 35, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [620], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Critical Strike (JP cost: 4200)',
'Desc2' => "Pony makes a single massive swing at the target, inflicting critical",
'Desc3' => "damage. Has a chance to instant kill a minion if its hp is low enough.",
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[2][37] = {
'Skill_id' => 622, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 33, # Skill to the left, 0 for none
'Right' => 41, # Skill to the right, 0 for none
'Down' => 38, # Skill below, 0 for none
'Up' => 40, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Sunder Arms (JP cost: 310)', # Description 1
'Desc2' => "Pony attempts to hinder the target's ability to fight back.",
'Desc3' => "Dealing normal damage and target suffer from ATK penalty.",
'JP' => 310,
}
#====================================================
#
#====================================================
Actor[2][38] = {
'Skill_id' =>623, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 34, # Skill to the left, 0 for none
'Right' => 42, # Skill to the right, 0 for none
'Down' => 39, # Skill below, 0 for none
'Up' => 37, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [622], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shattering Blows  (JP cost: 1000)', # Description 1
'Desc2' => "Pony is as adept at destruction as at death and gains a large damage ", # Description 2
'Desc3' => "bonus against heavy-armored enemies like golem and other constructs.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[2][39] = {
'Skill_id' => 624, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 35, # Skill to the left, 0 for none
'Right' => 43, # Skill to the right, 0 for none
'Down' => 40, # Skill below, 0 for none
'Up' => 38, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [623], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Sunder Armor (JP cost: 2050)', # Description 1
'Desc2' => "Pony aims a destructive blow at the target's armor or natural",
'Desc3' => "defenses. Dealing normal damage and lower its armor bouns as well.", # Description 3
'JP' => 2050,
}
#====================================================
#
#====================================================
Actor[2][40] = {
'Skill_id' =>625, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 36, # Skill to the left, 0 for none
'Right' => 44, # Skill to the right, 0 for none
'Down' => 37, # Skill below, 0 for none
'Up' => 39, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [624], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Destroyer (JP cost: 4800)', # Description 1
'Desc2' => "Few can stand against the savage blows of a destroyer. The", # Description 2
'Desc3' => "target you attacked critical will suffer from great DEF debuff.", # Description 3
'JP' => 4800,
}
#====================================================
#
#====================================================
Actor[2][41] = {
'Skill_id' => 626, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 37, # Skill to the left, 0 for none
'Right' => 45, # Skill to the right, 0 for none
'Down' => 42, # Skill below, 0 for none
'Up' => 44, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Mighty Blow (JP cost: 350)', # Description 1
'Desc2' => "Pony puts extra weight and effort behind a single strike. Deals CRI",
'Desc3' => "damage and lower target's AGI unless it passes STR saving throw.", # Description 3
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[2][42] = {
'Skill_id' => 627, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 38, # Skill to the left, 0 for none
'Right' => 46, # Skill to the right, 0 for none
'Down' => 43, # Skill below, 0 for none
'Up' => 41, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [626], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Powerful Swings (JP cost: 980)', # Description 1
'Desc2' => "In this mode, pony puts extra muscle behind each swing, gainging",
'Desc3' => "physical damage bonus but suffer DEF penalty.", # Description 3
'JP' => 980,
}
#====================================================
#
#====================================================
Actor[2][43] = {
'Skill_id' => 628, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 39, # Skill to the left, 0 for none
'Right' => 47, # Skill to the right, 0 for none
'Down' => 44, # Skill below, 0 for none
'Up' => 42, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [627], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Two-Hoofed Strength (JP cost: 2450)', # Description 1
'Desc2' => "Pony has learned how to wield 2-hoofed weapon efficiently. Receive EP",
'Desc3' => "payback after using 2-hoofed ability, lower Powerful Swing's penalty.", # Description 3
'JP' => 2450,
}
#====================================================
#
#====================================================
Actor[2][44] = {
'Skill_id' => 629, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 40, # Skill to the left, 0 for none
'Right' => 48, # Skill to the right, 0 for none
'Down' => 41, # Skill below, 0 for none
'Up' => 43, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [628], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Two-Hoofed Sweep (JP cost: 3800)', # Description 1
'Desc2' => "Pony swings a two-hoofed weapon through enemies in a vicious arc,", # Description 2
'Desc3' => "damaging and knock 'em down unless passes the STR saving throw.", # Description 3
'JP' => 3800,
}
#====================================================
#
#====================================================
Actor[2][45] = {
'Skill_id' => 630, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 41, # Skill to the left, 0 for none
'Right' => 33, # Skill to the right, 0 for none
'Down' => 46, # Skill below, 0 for none
'Up' => 48, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Sweeping Strike (JP cost: 1050)', # Description 1
'Desc2' => "A massive swing plows toward enemies, inflicting critical hit to the ",
'Desc3' => "targets in the range.",
'JP' => 1050,
}
#====================================================
#
#====================================================
Actor[2][46] = {
'Skill_id' => 631, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 42, # Skill to the left, 0 for none
'Right' => 34, # Skill to the right, 0 for none
'Down' => 47, # Skill below, 0 for none
'Up' => 45, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [630], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Two-Hoofed Impact (JP cost: 1980)', # Description 1
'Desc2' => "Generates a small shockwave that damages nearby targets. This" ,
'Desc3' => "skill can be chained after any offensive 2-hoofed ability.", # Description 3
'JP' => 1980,
}
#====================================================
#
#====================================================
Actor[2][47] = {
'Skill_id' => 632, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 43, # Skill to the left, 0 for none
'Right' => 35, # Skill to the right, 0 for none
'Down' => 48, # Skill below, 0 for none
'Up' => 46, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [631], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Onslaught (JP cost: 3200)', # Description 1
'Desc2' => "The pony advances several times, sweeping the weapon in huge ",
'Desc3' => "arcs that hit multiple enemies.",
'JP' => 3200,
}
#====================================================
#
#====================================================
Actor[2][48] = {
'Skill_id' => 633, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 44, # Skill to the left, 0 for none
'Right' => 36, # Skill to the right, 0 for none
'Down' => 45, # Skill below, 0 for none
'Up' => 47, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [632], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Reaving Storm (JP cost: 4500)', # Description 1
'Desc2' => "Once this skill is used, your pony turns continuously to attack",
'Desc3' => "surrounding enemies, this skill is able to keep chaining itself.",
'JP' => 4500,
}
#=========================================================================
# Actor 4 => PP Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
#====================================================
# Archery 1~16
#====================================================
Actor[4][1] = {
'Skill_id' =>546, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Shooting Posture (JP cost: 300)', # Description 1
'Desc2' => ' A right pose for pony to control a ranged weapon.', # Description 2
'Desc3' => ' +5% Hit rate', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[4][2] = {
'Skill_id' => 547, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [546], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Aim (JP cost: 800)', # Description 1
'Desc2' => ' Pony carefully place each shot for maximum effect. ', # Description 2
'Desc3' => ' +20% CRI, 300% aiming time.', # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[4][3] = {
'Skill_id' =>548, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [547], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Defensive Fire (JP cost: 1600)', # Description 1
'Desc2' => ' Defensive to the Offensive! ', # Description 2
'Desc3' => ' +25% DEF & MDF, 300% aiming time.', # Description 3
'JP' => 1600,
}
#====================================================
#
#====================================================
Actor[4][4] = {
'Skill_id' =>549, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [548], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Master Archer (JP cost: 3000)', # Description 1
'Desc2' => ' Pony now is expert in archery!', # Description 2
'Desc3' => ' Your archery skills all has unique bonus.', # Description 3
'JP' => 3000,
}
#====================================================
#
#====================================================
Actor[4][5] = {
'Skill_id' =>550, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Pinning Shot (JP cost: 300)', # Description 1
'Desc2' => " A shot to the target's legs disables the foe, pinning the target in place for a turn.", # Description 2
'Desc3' => ' +Tangle for 1 turn', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[4][6] = {
'Skill_id' =>551, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [550], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Crippling Shot (JP cost: 1000)', # Description 1
'Desc2' => "A carefully aimed shot hampers the target's ability.", # Description 2
'Desc3' => " Lower target's ATK,DEF,AGI by 5% ", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[4][7] = {
'Skill_id' =>552, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [551], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Critical Shot (JP cost: 2000)', # Description 1
'Desc2' => "Finding a chink in the target's defenses, and fire toward it.", # Description 2
'Desc3' => "Armor-piercing damage based on user's ATK&AGI", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[4][8] = {
'Skill_id' =>553, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [552], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Arrow of Slaying (JP cost: 4000)', # Description 1
'Desc2' => "Pony generates an deadly hit if this shot finds its target", # Description 2
'Desc3' => "Dealing considerable damage.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[4][9] = {
'Skill_id' =>554, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rapid Shot (JP cost: 350)', # Description 1
'Desc2' => "Speed wins out over power!", # Description 2
'Desc3' => "No aiming time required, but -15% CRI and 5% hit rate.", # Description 3
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[4][10] = {
'Skill_id' =>555, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [554], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shattering Shot (JP cost: 800)', # Description 1
'Desc2' => "Shot open up a weak spot in the target's armor.", # Description 2
'Desc3' => "Greatly lower target's DEF, dealing some damage as well.", # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[4][11] = {
'Skill_id' =>556, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [555], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Suppressing Fire (JP cost: 2250)', # Description 1
'Desc2' => "User's shots ncumbers the target.", # Description 2
'Desc3' => "Normal shots lower target ATK.", # Description 3
'JP' => 2250,
}
#====================================================
#
#====================================================
Actor[4][12] = {
'Skill_id' =>557, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [556], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Scattershot (JP cost: 4200)', # Description 1
'Desc2' => "Shot upon all foes, also stun them for a period.", # Description 2
'Desc3' => "Damage to all enemies, also stun them.", # Description 3
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[4][13] = {
'Skill_id' =>558, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Accuracy (JP cost: 400)', # Description 1
'Desc2' => "User is concentrate on the next hit.", # Description 2
'Desc3' => "User gains hit rate and damage bonus.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[4][14] = {
'Skill_id' =>559, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [558], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Arrow Time (JP cost: 1200)', # Description 1
'Desc2' => "Intense focus slows the archer's perception of time.", # Description 2
'Desc3' => "While aiming, slows others' ATB speed.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[4][15] = {
'Skill_id' =>560, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [559], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Burst Shot (JP cost: 2500)', # Description 1
'Desc2' => "The archer looses a special shaft that explode to dealing fire damage to all foes.",
'Desc3' => "Damage and knockback all foes.",
'JP' => 2500,
}
#====================================================
#
#====================================================
Actor[4][16] = {
'Skill_id' =>561, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Rain of Arrows (JP cost: 5000)', # Description 1
'Desc2' => "Pepper enemies.", # Description 2
'Desc3' => "Damage several random enemies.", # Description 3
'JP' => 5000,
}
#====================================================
#
#   17~32 : Weapon & Shield
#
#====================================================
#====================================================
#
#====================================================
Actor[4][17] = {
'Skill_id' =>584, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 29, # Skill to the left, 0 for none
'Right' => 21, # Skill to the right, 0 for none
'Down' => 18, # Skill below, 0 for none
'Up' => 20, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Bash', # Description 1
'Desc2' => 'Bash a target with shield, dealing normal damage', # Description 2
'Desc3' => 'and knocking the target off its feet.', # Description 3
}
#====================================================
#
#====================================================
Actor[4][18] = {
'Skill_id' => 585, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 30, # Skill to the left, 0 for none
'Right' => 22, # Skill to the right, 0 for none
'Down' => 19, # Skill below, 0 for none
'Up' => 17, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [584], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shield Pummel ', # Description 1
'Desc2' => 'Follows up an attack with two hit, stun target ', # Description 2
'Desc3' => 'and dealing normal damage with each attack.', # Description 3
}
#====================================================
#
#==============================5======================
Actor[4][19] = {
'Skill_id' =>586, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 31, # Skill to the left, 0 for none
'Right' => 23, # Skill to the right, 0 for none
'Down' => 20, # Skill below, 0 for none
'Up' => 18, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [585], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Overpower ', # Description 1
'Desc2' => 'Lashes out with the shield three times.',
'Desc3' => 'The last strike is a critical hit and knock the target down.',
}
#====================================================
#
#====================================================
Actor[4][20] = {
'Skill_id' =>587, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 32, # Skill to the left, 0 for none
'Right' => 24, # Skill to the right, 0 for none
'Down' => 17, # Skill below, 0 for none
'Up' => 19, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [586], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Assault', # Description 1
'Desc2' => 'Quickly strikes a target four times with more armor-',
'Desc3' => "piercing bonus, and last strike deals more damage.",
}
#====================================================
#
#====================================================
Actor[4][21] = {
'Skill_id' =>588, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 17, # Skill to the left, 0 for none
'Right' => 25, # Skill to the right, 0 for none
'Down' => 22, # Skill below, 0 for none
'Up' => 24, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Defense', # Description 1
'Desc2' => "This mode, pony will drops into a defensive stance",
'Desc3' => "that favors the shield. +5% chance block attacks.",
}
#====================================================
#
#====================================================
Actor[4][22] = {
'Skill_id' =>589, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 18, # Skill to the left, 0 for none
'Right' => 26, # Skill to the right, 0 for none
'Down' => 23, # Skill below, 0 for none
'Up' => 21, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [588], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Balance', # Description 1
'Desc2' => "Pony has learned to compensate for the weight of a shield in combat", # Description 2
'Desc3' => "No longer suffers an attack penalty while using Shield Defense.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][23] = {
'Skill_id' =>590, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 19, # Skill to the left, 0 for none
'Right' => 27, # Skill to the right, 0 for none
'Down' => 24, # Skill below, 0 for none
'Up' => 22, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [589], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Wall', # Description 1
'Desc2' => "Pony has 50%/20 more chance to block missile/other attack and", # Description 2
'Desc3' => "immune to stun. But greatly lower ATK,AGI and high fatigue.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][24] = {
'Skill_id' =>591, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 20, # Skill to the left, 0 for none
'Right' => 28, # Skill to the right, 0 for none
'Down' => 21, # Skill below, 0 for none
'Up' => 23, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [590], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Expertise', # Description 1
'Desc2' => "Pony's experience using a shield in combat has made certain talents", # Description 2
'Desc3' => "more efficient. Also +5% block when equipped a shield.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][25] = {
'Skill_id' =>592, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 21, # Skill to the left, 0 for none
'Right' => 29, # Skill to the right, 0 for none
'Down' => 26, # Skill below, 0 for none
'Up' => 28, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Block', # Description 1
'Desc2' => "Practice fighting with a shield improves the pony's guard", # Description 2
'Desc3' => "When equipped shield, +5% DEF and +2% missile block.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][26] = {
'Skill_id' =>593, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 22, # Skill to the left, 0 for none
'Right' => 30, # Skill to the right, 0 for none
'Down' => 27, # Skill below, 0 for none
'Up' => 25, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [592], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Cover', # Description 1
'Desc2' => "While in this mode, pony gains more missile block bonus", # Description 2
'Desc3' => "and reduce 5% physical damage when shield is equipped.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][27] = {
'Skill_id' =>594, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 23, # Skill to the left, 0 for none
'Right' => 31, # Skill to the right, 0 for none
'Down' => 28, # Skill below, 0 for none
'Up' => 26, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [593], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Tactics', # Description 1
'Desc2' => "Pony is proficient enough with a shield. When a shield is equipped and ", # Description 2
'Desc3' => "encounter a critical damage, cancel the critical if pass the saving throw.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][28] = {
'Skill_id' =>595, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 24, # Skill to the left, 0 for none
'Right' => 32, # Skill to the right, 0 for none
'Down' => 25, # Skill below, 0 for none
'Up' => 27, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [594], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Mastery', # Description 1
'Desc2' => "Pony has mastered the use of the shield for both offense and defense", # Description 2
'Desc3' => "Offensive abilities received the additional benefits.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][29] = {
'Skill_id' =>596, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 25, # Skill to the left, 0 for none
'Right' => 17, # Skill to the right, 0 for none
'Down' => 30, # Skill below, 0 for none
'Up' => 32, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Juggernaut', # Description 1
'Desc2' => "Gain more TP with each successful attack.",
'Desc3' => "",
}
#====================================================
#
#====================================================
Actor[4][30] = {
'Skill_id' =>597, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 26, # Skill to the left, 0 for none
'Right' => 18, # Skill to the right, 0 for none
'Down' => 31, # Skill below, 0 for none
'Up' => 29, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [596], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Carapace', # Description 1
'Desc2' => "No attack gets past this shield completely. For a moderate duration,", # Description 2
'Desc3' => "all damage is reduced by a amount based on your con.", # Description 3
}
#====================================================
#
#====================================================
Actor[4][31] = {
'Skill_id' =>598, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 27, # Skill to the left, 0 for none
'Right' => 19, # Skill to the right, 0 for none
'Down' => 32, # Skill below, 0 for none
'Up' => 30, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [597], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Air of Insolence', # Description 1
'Desc2' => "Your pony continuously draws the attention of nearby",
'Desc3' => "enemies. Higher targeted rate and provoke who attacks you.",
}
#====================================================
#
#====================================================
Actor[4][32] = {
'Skill_id' =>599, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 28, # Skill to the left, 0 for none
'Right' => 20, # Skill to the right, 0 for none
'Down' => 29, # Skill below, 0 for none
'Up' => 31, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Bulwark of the Ages', # Description 1
'Desc2' => "Upgrade the 'Carapace', character immune to first 3 damage,", # Description 2
'Desc3' => "and raise a few chance to block all damages.", # Description 3
}
#=========================================================================
# Actor 5 => RD Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
#====================================================
# Archery 1~16
#====================================================
Actor[5][1] = {
'Skill_id' =>546, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Shooting Posture (JP cost: 300)', # Description 1
'Desc2' => ' A right pose for pony to control a ranged weapon.', # Description 2
'Desc3' => ' +5% Hit rate', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[5][2] = {
'Skill_id' => 547, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [546], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Aim (JP cost: 800)', # Description 1
'Desc2' => ' Pony carefully place each shot for maximum effect. ', # Description 2
'Desc3' => ' +20% CRI, 300% aiming time.', # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[5][3] = {
'Skill_id' =>548, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [547], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Defensive Fire (JP cost: 1600)', # Description 1
'Desc2' => ' Defensive to the Offensive! ', # Description 2
'Desc3' => ' +25% DEF & MDF, 300% aiming time.', # Description 3
'JP' => 1600,
}
#====================================================
#
#====================================================
Actor[5][4] = {
'Skill_id' =>549, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [548], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Master Archer (JP cost: 3000)', # Description 1
'Desc2' => ' Pony now is expert in archery!', # Description 2
'Desc3' => ' Your archery skills all has unique bonus.', # Description 3
'JP' => 3000,
}
#====================================================
#
#====================================================
Actor[5][5] = {
'Skill_id' =>550, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Pinning Shot (JP cost: 300)', # Description 1
'Desc2' => " A shot to the target's legs disables the foe, pinning the target in place for a turn.", # Description 2
'Desc3' => ' +Tangle for 1 turn', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[5][6] = {
'Skill_id' =>551, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [550], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Crippling Shot (JP cost: 1000)', # Description 1
'Desc2' => "A carefully aimed shot hampers the target's ability.", # Description 2
'Desc3' => " Lower target's ATK,DEF,AGI by 5% ", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[5][7] = {
'Skill_id' =>552, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [551], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Critical Shot (JP cost: 2000)', # Description 1
'Desc2' => "Finding a chink in the target's defenses, and fire toward it.", # Description 2
'Desc3' => "Armor-piercing damage based on user's ATK&AGI", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[5][8] = {
'Skill_id' =>553, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [552], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Arrow of Slaying (JP cost: 4000)', # Description 1
'Desc2' => "Pony generates an deadly hit if this shot finds its target", # Description 2
'Desc3' => "Dealing considerable damage.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[5][9] = {
'Skill_id' =>554, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rapid Shot (JP cost: 350)', # Description 1
'Desc2' => "Speed wins out over power!", # Description 2
'Desc3' => "No aiming time required, but -15% CRI and 5% hit rate.", # Description 3
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[5][10] = {
'Skill_id' =>555, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [554], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shattering Shot (JP cost: 800)', # Description 1
'Desc2' => "Shot open up a weak spot in the target's armor.", # Description 2
'Desc3' => "Greatly lower target's DEF, dealing some damage as well.", # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[5][11] = {
'Skill_id' =>556, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [555], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Suppressing Fire (JP cost: 2250)', # Description 1
'Desc2' => "User's shots ncumbers the target.", # Description 2
'Desc3' => "Normal shots lower target ATK.", # Description 3
'JP' => 2250,
}
#====================================================
#
#====================================================
Actor[5][12] = {
'Skill_id' =>557, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [556], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Scattershot (JP cost: 4200)', # Description 1
'Desc2' => "Shot upon all foes, also stun them for a period.", # Description 2
'Desc3' => "Damage to all enemies, also stun them.", # Description 3
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[5][13] = {
'Skill_id' =>558, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Accuracy (JP cost: 400)', # Description 1
'Desc2' => "User is concentrate on the next hit.", # Description 2
'Desc3' => "User gains hit rate and damage bonus.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[5][14] = {
'Skill_id' =>559, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [558], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Arrow Time (JP cost: 1200)', # Description 1
'Desc2' => "Intense focus slows the archer's perception of time.", # Description 2
'Desc3' => "While aiming, slows others' ATB speed.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[5][15] = {
'Skill_id' =>560, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [559], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Burst Shot (JP cost: 2500)', # Description 1
'Desc2' => "The archer looses a special shaft that explode to dealing fire damage to all foes.",
'Desc3' => "Damage and knockback all foes.",
'JP' => 2500,
}
#====================================================
#
#====================================================
Actor[5][16] = {
'Skill_id' =>561, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Rain of Arrows (JP cost: 5000)', # Description 1
'Desc2' => "Pepper enemies.", # Description 2
'Desc3' => "Damage several random enemies.", # Description 3
'JP' => 5000,
}
#====================================================
#
#====================================================
#====================================================
#
#   17~32 : Dual Weapon
#
#====================================================
#====================================================
#
#====================================================
Actor[5][17] = {
'Skill_id' => 601, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 29, # Skill to the left, 0 for none
'Right' => 21, # Skill to the right, 0 for none
'Down' => 18, # Skill below, 0 for none
'Up' => 20, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Dual Weapon Training (JP cost: 300)', # Description 1
'Desc2' => 'Your pony has become more proficient fighting with two weapons,',
'Desc3' => 'reduce damage penalty to your off-hoof(dual weapon) weapon.', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[5][18] = {
'Skill_id' => 602, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 30, # Skill to the left, 0 for none
'Right' => 22, # Skill to the right, 0 for none
'Down' => 19, # Skill below, 0 for none
'Up' => 17, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [601], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Dual-Weapon Finesse (JP cost: 1000)', # Description 1
'Desc2' => 'Your pony is much skilled at wielding the dual weapon,', # Description 2
'Desc3' => 'off-hoof weapon deals closer damage to the another.', # Description 3
'JP' => 1000,
}
#====================================================
#
#==============================5======================
Actor[5][19] = {
'Skill_id' =>603, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 31, # Skill to the left, 0 for none
'Right' => 23, # Skill to the right, 0 for none
'Down' => 20, # Skill below, 0 for none
'Up' => 18, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [602], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Dual-Weapon Expert (JP cost: 2000)', # Description 1
'Desc2' => 'Your pony has significant experience with two-weapon fighting,',
'Desc3' => 'gaining more attack bonus when wielding dual weapon.',
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[5][20] = {
'Skill_id' =>604, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 32, # Skill to the left, 0 for none
'Right' => 24, # Skill to the right, 0 for none
'Down' => 17, # Skill below, 0 for none
'Up' => 19, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [603], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Dual-Weapon Mastery (JP cost: 4200)', # Description 1
'Desc2' => 'Only a chosen few truly master the complicated art of fighting with',
'Desc3' => "two weapons. Gaining critial bonus and has a chance to cause bleed.",
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[5][21] = {
'Skill_id' =>605, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 17, # Skill to the left, 0 for none
'Right' => 25, # Skill to the right, 0 for none
'Down' => 22, # Skill below, 0 for none
'Up' => 24, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Dual Striking (JP cost: 350)', # Description 1
'Desc2' => "This mode, pony will strikes with both weapons simultaneously.",
'Desc3' => "Dealing more damage but +20% fatigue.",
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[5][22] = {
'Skill_id' =>606, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 18, # Skill to the left, 0 for none
'Right' => 26, # Skill to the right, 0 for none
'Down' => 23, # Skill below, 0 for none
'Up' => 21, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [605], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Riposte (JP cost: 1200)', # Description 1
'Desc2' => "Pony strikes at a target once, and stunning the opponent unless it", # Description 2
'Desc3' => "passes saving throw. Then the second hit will be critial if it's stunned.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[5][23] = {
'Skill_id' =>607, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 19, # Skill to the left, 0 for none
'Right' => 27, # Skill to the right, 0 for none
'Down' => 24, # Skill below, 0 for none
'Up' => 22, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [606], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Cripple (JP cost: 2300)', # Description 1
'Desc2' => "The pony strikes low at the target, casuing a critial but less ",
'Desc3' => "damage meanwhile lower its DEF and AGI.", # Description 3
'JP' => 2300,
}
#====================================================
#
#====================================================
Actor[5][24] = {
'Skill_id' =>608, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 20, # Skill to the left, 0 for none
'Right' => 28, # Skill to the right, 0 for none
'Down' => 21, # Skill below, 0 for none
'Up' => 23, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [607], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Punisher (JP cost: 4250)', # Description 1
'Desc2' => "Pony makes three blows against a target, the first two hit dealing normal", # Description 2
'Desc3' => "damage and the final inflicting a critical, also lower its ATK/MAT.", # Description 3
'JP' => 4250,
}
#====================================================
#
#====================================================
Actor[5][25] = {
'Skill_id' =>609, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 21, # Skill to the left, 0 for none
'Right' => 29, # Skill to the right, 0 for none
'Down' => 26, # Skill below, 0 for none
'Up' => 28, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Dual-Weapon Sweap (JP cost: 400)', # Description 1
'Desc2' => "Pony sweeps both weapons in a broad forward arc, striking nearby enemies", # Description 2
'Desc3' => "with both weapons and inflicting significantly more damage than normal.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[5][26] = {
'Skill_id' =>610, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 22, # Skill to the left, 0 for none
'Right' => 30, # Skill to the right, 0 for none
'Down' => 27, # Skill below, 0 for none
'Up' => 25, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [609], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Flurry (JP cost: 1000)', # Description 1
'Desc2' => "Pony lashes out with a flurry of three blows,", # Description 2
'Desc3' => "dealing less normal damage with each hit.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[5][27] = {
'Skill_id' =>611, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 23, # Skill to the left, 0 for none
'Right' => 31, # Skill to the right, 0 for none
'Down' => 28, # Skill below, 0 for none
'Up' => 26, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [610], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Momentum (JP cost: 1500)', # Description 1
'Desc2' => "Each of your successful hit will increase your begin AT in",
'Desc3' => "next turn, max to 15%.",
'JP' => 1500,
}
#====================================================
#
#====================================================
Actor[5][28] = {
'Skill_id' =>612, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 24, # Skill to the left, 0 for none
'Right' => 32, # Skill to the right, 0 for none
'Down' => 25, # Skill below, 0 for none
'Up' => 27, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [611], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Whirlwind (JP cost: 4500)', # Description 1
'Desc2' => "Pony flies into a whirling dance of death, striking out", # Description 2
'Desc3' => "nearby enemies. Each hit deals normal combat damage.", # Description 3
'JP' => 4500,
}
#====================================================
#
#====================================================
Actor[5][29] = {
'Skill_id' =>613, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 25, # Skill to the left, 0 for none
'Right' => 17, # Skill to the right, 0 for none
'Down' => 30, # Skill below, 0 for none
'Up' => 32, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Twin Strike (JP cost: 800)', # Description 1
'Desc2' => "Two devastating strikes in rapid succession each",
'Desc3' => "inflict an automatic critical hit.",
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[5][30] = {
'Skill_id' =>614, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 26, # Skill to the left, 0 for none
'Right' => 18, # Skill to the right, 0 for none
'Down' => 31, # Skill below, 0 for none
'Up' => 29, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [613], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Find Vitals (JP cost: 1200)', # Description 1
'Desc2' => "The pony is a force of nature when wielding two weapons.", # Description 2
'Desc3' => "gaining CRI bonus and twin strike will also cause bleeding.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[5][31] = {
'Skill_id' =>615, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 27, # Skill to the left, 0 for none
'Right' => 19, # Skill to the right, 0 for none
'Down' => 32, # Skill below, 0 for none
'Up' => 30, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [614], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Low Blow (JP cost: 2000)', # Description 1
'Desc2' => "The pony strikes at the legs of the opponent. Makes it suffer from",
'Desc3' => "AGI penalty; if the target is bleeding, knocks it down as well.",
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[5][32] = {
'Skill_id' =>616, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 28, # Skill to the left, 0 for none
'Right' => 20, # Skill to the right, 0 for none
'Down' => 29, # Skill below, 0 for none
'Up' => 31, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [615], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Unending Flurry (JP cost: 4800)', # Description 1
'Desc2' => "Your pony singles out an enemy for death...pony able to perform",
'Desc3' => "double slash after any dual-weapon skills.", # Description 3
'JP' => 4800,
}
#====================================================
#
#   33~48 : Scout
#
#====================================================
#====================================================
#
#====================================================
Actor[5][33] = {
'Skill_id' => 635, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 45, # Skill to the left, 0 for none
'Right' => 37, # Skill to the right, 0 for none
'Down' => 34, # Skill below, 0 for none
'Up' => 36, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Dirty Fighting (JP cost: 520)', # Description 1
'Desc2' => 'Your pony incapacitates a target, who takes no damage from the attack',
'Desc3' => 'but interrupt skill casting.', # Description 3
'JP' => 520,
}
#====================================================
#
#====================================================
Actor[5][34] = {
'Skill_id' => 636, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 46, # Skill to the left, 0 for none
'Right' => 38, # Skill to the right, 0 for none
'Down' => 35, # Skill below, 0 for none
'Up' => 33, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [601], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Combat Movement (JP cost: 1400)', # Description 1
'Desc2' => 'A quick-stepping poni can more easily outmaneuver opponents.', # Description 2
'Desc3' => 'Gaining extra AT after action end that based on your d20 result.', # Description 3
'JP' => 1400,
}
#====================================================
#
#==============================5======================
Actor[5][35] = {
'Skill_id' =>637, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 47, # Skill to the left, 0 for none
'Right' => 39, # Skill to the right, 0 for none
'Down' => 36, # Skill below, 0 for none
'Up' => 34, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [602], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Coup De Grace (JP cost: 3200)', # Description 1
'Desc2' => "When a target is incapacitated, pony's normal attack will", # Description 2
'Desc3' => 'inflict quadruple damage; attacks will be critical.', # Description 3
'JP' => 3200,
}
#====================================================
#
#====================================================
Actor[5][36] = {
'Skill_id' =>638, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 48, # Skill to the left, 0 for none
'Right' => 40, # Skill to the right, 0 for none
'Down' => 33, # Skill below, 0 for none
'Up' => 35, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [603], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Feign Death (JP cost: 4600)', # Description 1
'Desc2' => "Pony collapses at the enemies' feet, lower TGR to zero",
'Desc3' => 'and resist half of upcoming damage until nex turn.',
'JP' => 4600,
}
#====================================================
#
#====================================================
Actor[5][37] = {
'Skill_id' =>639, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 33, # Skill to the left, 0 for none
'Right' => 41, # Skill to the right, 0 for none
'Down' => 38, # Skill below, 0 for none
'Up' => 40, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Below the Belt (JP cost: 320)', # Description 1
'Desc2' => "Pony delivers a swift and unsportsmanlike kick to the target,",
'Desc3' => "imposing penalties to DEF and AGI unless passes the saving throw.",
'JP' => 320,
}
#====================================================
#
#====================================================
Actor[5][38] = {
'Skill_id' =>640, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 34, # Skill to the left, 0 for none
'Right' => 42, # Skill to the right, 0 for none
'Down' => 39, # Skill below, 0 for none
'Up' => 37, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [605], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Deadly Strike(JP cost: 1060)', # Description 1
'Desc2' => "Pony makes a swift strike at a vulnerable area on the target,", # Description 2
'Desc3' => "dealing normal damage but ignore its defence.", # Description 3
'JP' => 1060,
}
#====================================================
#
#====================================================
Actor[5][39] = {
'Skill_id' =>641, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 35, # Skill to the left, 0 for none
'Right' => 43, # Skill to the right, 0 for none
'Down' => 40, # Skill below, 0 for none
'Up' => 38, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [606], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Lethality (JP cost: 2250)', # Description 1
'Desc2' => "The pony has a keen eye for weak spots, and thus gains a bonus to",
'Desc3' => "critical chance for all attacks.", # Description 3
'JP' => 2250,
}
#====================================================
#
#====================================================
Actor[5][40] = {
'Skill_id' =>642, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 36, # Skill to the left, 0 for none
'Right' => 44, # Skill to the right, 0 for none
'Down' => 37, # Skill below, 0 for none
'Up' => 39, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [607], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Evasion (JP cost: 4500)', # Description 1
'Desc2' => "Pony gains an almost preternatural ability to sense and avoid danger.", # Description 2
'Desc3' => "Granting 10% EVA and stun resistance.(still weaker than Pinkie Sense, though)", # Description 3
'JP' => 4500,
}
#====================================================
#
#====================================================
Actor[5][41] = {
'Skill_id' =>643, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 37, # Skill to the left, 0 for none
'Right' => 45, # Skill to the right, 0 for none
'Down' => 42, # Skill below, 0 for none
'Up' => 44, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Heart Seeker (JP cost: 1800)', # Description 1
'Desc2' => "Pony strikes with great precision, attempting to fell weakened enemies", # Description 2
'Desc3' => "in one last blow. Instant kill minion, critical damage to elite rank foe.", # Description 3
'JP' => 1800,
}
#====================================================
#
#====================================================
Actor[5][42] = {
'Skill_id' =>644, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 38, # Skill to the left, 0 for none
'Right' => 46, # Skill to the right, 0 for none
'Down' => 43, # Skill below, 0 for none
'Up' => 41, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [609], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Ghost (JP cost: 2800)', # Description 1
'Desc2' => "Pony melts into the shadows, completely evading enemies'", # Description 2
'Desc3' => "physical attacks for a short time.", # Description 3
'JP' => 2800,
}
#====================================================
#
#====================================================
Actor[5][43] = {
'Skill_id' =>645, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 39, # Skill to the left, 0 for none
'Right' => 47, # Skill to the right, 0 for none
'Down' => 44, # Skill below, 0 for none
'Up' => 42, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [610], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Weak Points (JP cost: 3720)', # Description 1
'Desc2' => "While this mode actived, pony seeks out enemies' weak points,", # Description 2
'Desc3' => "striking each target in a manner that increases all damage.", # Description 3
'JP' => 3720,
}
#====================================================
#
#====================================================
Actor[5][44] = {
'Skill_id' =>646, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 40, # Skill to the left, 0 for none
'Right' => 48, # Skill to the right, 0 for none
'Down' => 41, # Skill below, 0 for none
'Up' => 42, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [611], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Flicker (JP cost: 5200)', # Description 1
'Desc2' => "The pony's deadly speed is unmatched. Sprinting from target to targe", # Description 2
'Desc3' => "to strike them that infltct a armor-piercing and critical damage.", # Description 3
'JP' => 5200,
}
#====================================================
#
#====================================================
Actor[5][45] = {
'Skill_id' =>647, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 41, # Skill to the left, 0 for none
'Right' => 33, # Skill to the right, 0 for none
'Down' => 46, # Skill below, 0 for none
'Up' => 48, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Mark of Death (JP cost: 1000)', # Description 1
'Desc2' => "Pony marks a target, revealing weaknesses that others can exploit.",
'Desc3' => "All attacks against a marked target deal additional damage.",
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[5][46] = {
'Skill_id' =>648, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 42, # Skill to the left, 0 for none
'Right' => 34, # Skill to the right, 0 for none
'Down' => 47, # Skill below, 0 for none
'Up' => 45, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [613], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Exploit Weakness (JP cost: 1400)', # Description 1
'Desc2' => "A keen eye and a killer instinct help the pony exploit a target's", # Description 2
'Desc3' => "weak points. +30% bonus to the critical modifier.", # Description 3
'JP' => 1400,
}
#====================================================
#
#====================================================
Actor[5][47] = {
'Skill_id' =>649, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 43, # Skill to the left, 0 for none
'Right' => 35, # Skill to the right, 0 for none
'Down' => 48, # Skill below, 0 for none
'Up' => 46, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [614], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Lacerate (JP cost: 2400)', # Description 1
'Desc2' => "Whenever a success attackful is made, the tharget will",
'Desc3' => "bleeding that will increase the damage taken.",
'JP' => 2400,
}
#====================================================
#
#====================================================
Actor[5][48] = {
'Skill_id' =>650, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 3, # The tree that this skill is on
'Left' => 44, # Skill to the left, 0 for none
'Right' => 36, # Skill to the right, 0 for none
'Down' => 45, # Skill below, 0 for none
'Up' => 47, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [615], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Feast of the Fallen (JP cost: 5800)', # Description 1
'Desc2' => "The pony thrives on the moment of massacre. Restore HP",
'Desc3' => "and EP whenever the pony hits an enemy. Terrifying, huh?", # Description 3
'JP' => 5800,
}
#=========================================================================
# Actor 6 => RR Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
  #=========================================================================
  # Actor 6 => 
  #=========================================================================
#==========================================================================
#   Primal 1 ~ 16
#==========================================================================
Actor[6][1] = {
'Skill_id' =>563, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Flame Blast(JP cost: 300)', # Description 1
'Desc2' => ' Inflicting fire damage on all targets in the area.', # Description 2
'Desc3' => ' Casue fire damage in (120-0 , 5-5) rectangle', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[6][2] = {
'Skill_id' => 564, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [563], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Flaming Bless (JP cost: 1000)', # Description 1
'Desc2' => " Boost all allies' flame resist, ", # Description 2
'Desc3' => ' normal attack have flame attack bonus, double fire damage.', # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[6][3] = {
'Skill_id' =>565, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [564], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Fireball (JP cost: 2000)', # Description 1
'Desc2' => ' Inflicting fire damgage in AOE + knockback.', # Description 2
'Desc3' => " AOE:(120-120 , 120-50), target's AT drop to zero.", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[6][4] = {
'Skill_id' =>566, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [565], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Inferno (JP cost: 3800)', # Description 1
'Desc2' => ' The caster summons a huge column of swirling flame.', # Description 2
'Desc3' => 'For 5 turns, enemies suffer from fire in every end of turn. ', # Description 3
'JP' => 3800,
}
#====================================================
#
#====================================================
Actor[6][5] = {
'Skill_id' =>568, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rock Armor (JP cost: 300)', # Description 1
'Desc2' => " Caster's skin is as hard as stone.", # Description 2
'Desc3' => " Double caster's DEF and resist half earth and physical damage.", # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[6][6] = {
'Skill_id' =>569, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [568], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Stonefist (JP cost: 1000)', # Description 1
'Desc2' => "Hurls a stone projectile that knocks down the target.", # Description 2
'Desc3' => "If target is petrified or frozen, dealing massive earth damage.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[6][7] = {
'Skill_id' =>570, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [569], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Earthquake (JP cost: 2000)', # Description 1
'Desc2' => "Causing a violent quake, last for 4 turns. Knockback all foes", # Description 2
'Desc3' => "in every end of turn unless they pass the saving throw.", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[6][8] = {
'Skill_id' =>572, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [570], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Petrify (JP cost: 4000)', # Description 1
'Desc2' => "Turn a target into a stone unless pass the saving throw.", # Description 2
'Desc3' => "Petrified will last forever unless somepony rescue him/her.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[6][9] = {
'Skill_id' =>573, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Winter Grasp (JP cost: 300)', # Description 1
'Desc2' => "The caster envelops the target in frost.", # Description 2
'Desc3' => "Chill target, if it have been chilled then frozen.", # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[6][10] = {
'Skill_id' =>574, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [573], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Frost Bless (JP cost: 1000)', # Description 1
'Desc2' => "Boost all allies' ice resist", # Description 2
'Desc3' => "normal attack have ice attack bonus, 1.5x ice damage.", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[6][11] = {
'Skill_id' =>575, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [574], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Cone of Cold (JP cost: 2300)', # Description 1
'Desc2' => "Erupts with a cone of frost, damaging foes in AOE,", # Description 2
'Desc3' => "freezing targets unless they pass the saving throw.", # Description 3
'JP' => 2300,
}
#====================================================
#
#====================================================
Actor[6][12] = {
'Skill_id' =>576, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [575], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Blizzard (JP cost: 4000)', # Description 1
'Desc2' => "For 5 turns,an ice storm deals continuous cold damage.", # Description 2
'Desc3' => "Slows foe's movement speed every end of turn.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[6][13] = {
'Skill_id' =>578, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Lighting Bolt (JP cost: 400)', # Description 1
'Desc2' => "Caster fires a bolt of lighting at the target.", # Description 2
'Desc3' => "Dealing thunder damage.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[6][14] = {
'Skill_id' =>579, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [578], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shock (JP cost: 1100)', # Description 1
'Desc2' => "The caster's hoof erupt, emitting a cone of lightning.", # Description 2
'Desc3' => "Damaging all targets in the area. ", # Description 3
'JP' => 1100,
}
#====================================================
#
#====================================================
Actor[6][15] = {
'Skill_id' =>580, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [579], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Tempeset (JP cost: 2400)', # Description 1
'Desc2' => "The caster unleashes a fierce lightning storm. For 5 turns, ",
'Desc3' => "all foes take thunder damage in every end of turn.",
'JP' => 2400,
}
#====================================================
#
#====================================================
Actor[6][16] = {
'Skill_id' =>582, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [580], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Chain Lighting (JP cost: 5000)', # Description 1
'Desc2' => "Emitting a bolt of lightning on a target, then forks,", # Description 2
'Desc3' => "sending smaller bolts jumping to those nearby, which fork again.", # Description 3
'JP' => 5000,
}
#====================================================
#
#====================================================
Actor[6][17] = {
'Skill_id' =>561, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Rain of Arrows', # Description 1
'Desc2' => "Pepper enemies.", # Description 2
'Desc3' => "Damage several random enemies with great armor-piercing bonus.", # Description 3
}
#=========================================================================
# Actor 7 => FS Main Configuration
# Note that 0 on the skill parts is the main configuration for that actor.
#=========================================================================
#====================================================
# Archery 1~16
#====================================================
Actor[7][1] = {
'Skill_id' =>546, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 13, # Skill to the left, 0 for none
'Right' => 5, # Skill to the right, 0 for none
'Down' => 2, # Skill below, 0 for none
'Up' => 4, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Shooting Posture (JP cost: 300)', # Description 1
'Desc2' => ' A right pose for pony to control a ranged weapon.', # Description 2
'Desc3' => ' +5% Hit rate', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[7][2] = {
'Skill_id' => 547, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 14, # Skill to the left, 0 for none
'Right' => 6, # Skill to the right, 0 for none
'Down' => 3, # Skill below, 0 for none
'Up' => 1, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [546], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Aim (JP cost: 800)', # Description 1
'Desc2' => ' Pony carefully place each shot for maximum effect. ', # Description 2
'Desc3' => ' +20% CRI, 300% aiming time.', # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[7][3] = {
'Skill_id' =>548, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 15, # Skill to the left, 0 for none
'Right' => 7, # Skill to the right, 0 for none
'Down' => 4, # Skill below, 0 for none
'Up' => 2, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [547], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Defensive Fire (JP cost: 1600)', # Description 1
'Desc2' => ' Defensive to the Offensive! ', # Description 2
'Desc3' => ' +25% DEF & MDF, 300% aiming time.', # Description 3
'JP' => 1600,
}
#====================================================
#
#====================================================
Actor[7][4] = {
'Skill_id' =>549, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 16, # Skill to the left, 0 for none
'Right' => 8, # Skill to the right, 0 for none
'Down' => 1, # Skill below, 0 for none
'Up' => 3, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [548], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Master Archer (JP cost: 3000)', # Description 1
'Desc2' => ' Pony now is expert in archery!', # Description 2
'Desc3' => ' Your archery skills all has unique bonus.', # Description 3
'JP' => 3000,
}
#====================================================
#
#====================================================
Actor[7][5] = {
'Skill_id' =>550, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 1, # Skill to the left, 0 for none
'Right' => 9, # Skill to the right, 0 for none
'Down' => 6, # Skill below, 0 for none
'Up' => 8, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Pinning Shot (JP cost: 300)', # Description 1
'Desc2' => " A shot to the target's legs disables the foe, pinning the target in place for a turn.", # Description 2
'Desc3' => ' +Tangle for 1 turn', # Description 3
'JP' => 300,
}
#====================================================
#
#====================================================
Actor[7][6] = {
'Skill_id' =>551, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 2, # Skill to the left, 0 for none
'Right' => 10, # Skill to the right, 0 for none
'Down' => 7, # Skill below, 0 for none
'Up' => 5, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [550], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Crippling Shot (JP cost: 1000)', # Description 1
'Desc2' => "A carefully aimed shot hampers the target's ability.", # Description 2
'Desc3' => " Lower target's ATK,DEF,AGI by 5% ", # Description 3
'JP' => 1000,
}
#====================================================
#
#====================================================
Actor[7][7] = {
'Skill_id' =>552, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 3, # Skill to the left, 0 for none
'Right' => 11, # Skill to the right, 0 for none
'Down' => 8, # Skill below, 0 for none
'Up' => 6, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [551], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Critical Shot (JP cost: 2000)', # Description 1
'Desc2' => "Finding a chink in the target's defenses, and fire toward it.", # Description 2
'Desc3' => "Armor-piercing damage based on user's ATK&AGI", # Description 3
'JP' => 2000,
}
#====================================================
#
#====================================================
Actor[7][8] = {
'Skill_id' =>553, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 4, # Skill to the left, 0 for none
'Right' => 12, # Skill to the right, 0 for none
'Down' => 5, # Skill below, 0 for none
'Up' => 7, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [552], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Arrow of Slaying (JP cost: 4000)', # Description 1
'Desc2' => "Pony generates an deadly hit if this shot finds its target", # Description 2
'Desc3' => "Dealing considerable damage.", # Description 3
'JP' => 4000,
}
#====================================================
#
#====================================================
Actor[7][9] = {
'Skill_id' =>554, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 5, # Skill to the left, 0 for none
'Right' => 13, # Skill to the right, 0 for none
'Down' => 10, # Skill below, 0 for none
'Up' => 12, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => ' Rapid Shot (JP cost: 350)', # Description 1
'Desc2' => "Speed wins out over power!", # Description 2
'Desc3' => "No aiming time required, but -15% CRI and 5% hit rate.", # Description 3
'JP' => 350,
}
#====================================================
#
#====================================================
Actor[7][10] = {
'Skill_id' =>555, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 6, # Skill to the left, 0 for none
'Right' => 14, # Skill to the right, 0 for none
'Down' => 11, # Skill below, 0 for none
'Up' => 9, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [554], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shattering Shot (JP cost: 800)', # Description 1
'Desc2' => "Shot open up a weak spot in the target's armor.", # Description 2
'Desc3' => "Greatly lower target's DEF, dealing some damage as well.", # Description 3
'JP' => 800,
}
#====================================================
#
#====================================================
Actor[7][11] = {
'Skill_id' =>556, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 7, # Skill to the left, 0 for none
'Right' => 15, # Skill to the right, 0 for none
'Down' => 12, # Skill below, 0 for none
'Up' => 10, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [555], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Suppressing Fire (JP cost: 2250)', # Description 1
'Desc2' => "User's shots ncumbers the target.", # Description 2
'Desc3' => "Normal shots lower target ATK.", # Description 3
'JP' => 2250,
}
#====================================================
#
#====================================================
Actor[7][12] = {
'Skill_id' =>557, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 8, # Skill to the left, 0 for none
'Right' => 16, # Skill to the right, 0 for none
'Down' => 9, # Skill below, 0 for none
'Up' => 11, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [556], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Scattershot (JP cost: 4200)', # Description 1
'Desc2' => "Shot upon all foes, also stun them for a period.", # Description 2
'Desc3' => "Damage to all enemies, also stun them.", # Description 3
'JP' => 4200,
}
#====================================================
#
#====================================================
Actor[7][13] = {
'Skill_id' =>558, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 9, # Skill to the left, 0 for none
'Right' => 1, # Skill to the right, 0 for none
'Down' => 14, # Skill below, 0 for none
'Up' => 16, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Accuracy (JP cost: 400)', # Description 1
'Desc2' => "User is concentrate on the next hit.", # Description 2
'Desc3' => "User gains hit rate and damage bonus.", # Description 3
'JP' => 400,
}
#====================================================
#
#====================================================
Actor[7][14] = {
'Skill_id' =>559, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 10, # Skill to the left, 0 for none
'Right' => 2, # Skill to the right, 0 for none
'Down' => 15, # Skill below, 0 for none
'Up' => 13, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [558], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Arrow Time (JP cost: 1200)', # Description 1
'Desc2' => "Intense focus slows the archer's perception of time.", # Description 2
'Desc3' => "While aiming, slows others' ATB speed.", # Description 3
'JP' => 1200,
}
#====================================================
#
#====================================================
Actor[7][15] = {
'Skill_id' =>560, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 11, # Skill to the left, 0 for none
'Right' => 3, # Skill to the right, 0 for none
'Down' => 16, # Skill below, 0 for none
'Up' => 14, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [559], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Burst Shot (JP cost: 2500)', # Description 1
'Desc2' => "The archer looses a special shaft that explode to dealing fire damage to all foes.",
'Desc3' => "Damage and knockback all foes.",
'JP' => 2500,
}
#====================================================
#
#====================================================
Actor[7][16] = {
'Skill_id' =>561, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 1, # The tree that this skill is on
'Left' => 12, # Skill to the left, 0 for none
'Right' => 4, # Skill to the right, 0 for none
'Down' => 13, # Skill below, 0 for none
'Up' => 15, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Rain of Arrows (JP cost: 5000)', # Description 1
'Desc2' => "Pepper enemies.", # Description 2
'Desc3' => "Damage several random enemies.", # Description 3
'JP' => 5000,
}
#====================================================
#
#   17~32 : Weapon & Shield
#
#====================================================
#====================================================
#
#====================================================
Actor[7][17] = {
'Skill_id' =>584, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 29, # Skill to the left, 0 for none
'Right' => 21, # Skill to the right, 0 for none
'Down' => 18, # Skill below, 0 for none
'Up' => 20, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Bash', # Description 1
'Desc2' => 'Bash a target with shield, dealing normal damage', # Description 2
'Desc3' => 'and knocking the target off its feet.', # Description 3
}
#====================================================
#
#====================================================
Actor[7][18] = {
'Skill_id' => 585, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 30, # Skill to the left, 0 for none
'Right' => 22, # Skill to the right, 0 for none
'Down' => 19, # Skill below, 0 for none
'Up' => 17, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [584], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Shield Pummel ', # Description 1
'Desc2' => 'Follows up an attack with two hit, stun target ', # Description 2
'Desc3' => 'and dealing normal damage with each attack.', # Description 3
}
#====================================================
#
#==============================5======================
Actor[7][19] = {
'Skill_id' =>586, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 31, # Skill to the left, 0 for none
'Right' => 23, # Skill to the right, 0 for none
'Down' => 20, # Skill below, 0 for none
'Up' => 18, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [585], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => ' Overpower ', # Description 1
'Desc2' => 'Lashes out with the shield three times.',
'Desc3' => 'The last strike is a critical hit and knock the target down.',
}
#====================================================
#
#====================================================
Actor[7][20] = {
'Skill_id' =>587, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 30, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 32, # Skill to the left, 0 for none
'Right' => 24, # Skill to the right, 0 for none
'Down' => 17, # Skill below, 0 for none
'Up' => 19, # Skill above, 0 for none
'X' => 10, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [586], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Assault', # Description 1
'Desc2' => 'Quickly strikes a target four times with more armor-',
'Desc3' => "piercing bonus, and last strike deals more damage.",
}
#====================================================
#
#====================================================
Actor[7][21] = {
'Skill_id' =>588, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 17, # Skill to the left, 0 for none
'Right' => 25, # Skill to the right, 0 for none
'Down' => 22, # Skill below, 0 for none
'Up' => 24, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Defense', # Description 1
'Desc2' => "This mode, pony will drops into a defensive stance",
'Desc3' => "that favors the shield. +5% chance block attacks.",
}
#====================================================
#
#====================================================
Actor[7][22] = {
'Skill_id' =>589, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 18, # Skill to the left, 0 for none
'Right' => 26, # Skill to the right, 0 for none
'Down' => 23, # Skill below, 0 for none
'Up' => 21, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [588], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Balance', # Description 1
'Desc2' => "Pony has learned to compensate for the weight of a shield in combat", # Description 2
'Desc3' => "No longer suffers an attack penalty while using Shield Defense.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][23] = {
'Skill_id' =>590, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 19, # Skill to the left, 0 for none
'Right' => 27, # Skill to the right, 0 for none
'Down' => 24, # Skill below, 0 for none
'Up' => 22, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 195, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [589], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Wall', # Description 1
'Desc2' => "Pony has 50%/20 more chance to block missile/other attack and", # Description 2
'Desc3' => "immune to stun. But greatly lower ATK,AGI and high fatigue.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][24] = {
'Skill_id' =>591, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 20, # Skill to the left, 0 for none
'Right' => 28, # Skill to the right, 0 for none
'Down' => 21, # Skill below, 0 for none
'Up' => 23, # Skill above, 0 for none
'X' => 90, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [590], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Expertise', # Description 1
'Desc2' => "Pony's experience using a shield in combat has made certain talents", # Description 2
'Desc3' => "more efficient. Also +5% block when equipped a shield.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][25] = {
'Skill_id' =>592, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 21, # Skill to the left, 0 for none
'Right' => 29, # Skill to the right, 0 for none
'Down' => 26, # Skill below, 0 for none
'Up' => 28, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Block', # Description 1
'Desc2' => "Practice fighting with a shield improves the pony's guard", # Description 2
'Desc3' => "When equipped shield, +5% DEF and +2% missile block.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][26] = {
'Skill_id' =>593, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 22, # Skill to the left, 0 for none
'Right' => 30, # Skill to the right, 0 for none
'Down' => 27, # Skill below, 0 for none
'Up' => 25, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [592], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Cover', # Description 1
'Desc2' => "While in this mode, pony gains more missile block bonus", # Description 2
'Desc3' => "and reduce 5% physical damage when shield is equipped.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][27] = {
'Skill_id' =>594, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 23, # Skill to the left, 0 for none
'Right' => 31, # Skill to the right, 0 for none
'Down' => 28, # Skill below, 0 for none
'Up' => 26, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [593], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Tactics', # Description 1
'Desc2' => "Pony is proficient enough with a shield. When a shield is equipped and ", # Description 2
'Desc3' => "encounter a critical damage, cancel the critical if pass the saving throw.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][28] = {
'Skill_id' =>595, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 24, # Skill to the left, 0 for none
'Right' => 32, # Skill to the right, 0 for none
'Down' => 25, # Skill below, 0 for none
'Up' => 27, # Skill above, 0 for none
'X' => 170, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [594], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Shield Mastery', # Description 1
'Desc2' => "Pony has mastered the use of the shield for both offense and defense", # Description 2
'Desc3' => "Offensive abilities received the additional benefits.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][29] = {
'Skill_id' =>596, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 25, # Skill to the left, 0 for none
'Right' => 17, # Skill to the right, 0 for none
'Down' => 30, # Skill below, 0 for none
'Up' => 32, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 10, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [], # Needed skills to open this skill, any quantity
'Req_levels' => [], # Same as above, but with the levels of each skill
'Desc1' => 'Juggernaut', # Description 1
'Desc2' => "Gain more TP with each successful attack.",
'Desc3' => "",
}
#====================================================
#
#====================================================
Actor[7][30] = {
'Skill_id' =>597, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 26, # Skill to the left, 0 for none
'Right' => 18, # Skill to the right, 0 for none
'Down' => 31, # Skill below, 0 for none
'Up' => 29, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 100, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [596], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Carapace', # Description 1
'Desc2' => "No attack gets past this shield completely. For a moderate duration,", # Description 2
'Desc3' => "all damage is reduced by a amount based on your con.", # Description 3
}
#====================================================
#
#====================================================
Actor[7][31] = {
'Skill_id' =>598, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 27, # Skill to the left, 0 for none
'Right' => 19, # Skill to the right, 0 for none
'Down' => 32, # Skill below, 0 for none
'Up' => 30, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 194, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [597], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Air of Insolence', # Description 1
'Desc2' => "Your pony continuously draws the attention of nearby",
'Desc3' => "enemies. Higher targeted rate and provoke who attacks you.",
}
#====================================================
#
#====================================================
Actor[7][32] = {
'Skill_id' =>599, # Skill ID in the Database
'Maxlevel' => 1, # Skill Maximum Level
'Multiply' => 0, # Effect Multiplier in %, 100 = 100%
'Level' => 1, # Necessary level to add points on the skill
'Level_Add' => 1, # Level Restriction for every point on the skill
'Tree' => 2, # The tree that this skill is on
'Left' => 28, # Skill to the left, 0 for none
'Right' => 20, # Skill to the right, 0 for none
'Down' => 29, # Skill below, 0 for none
'Up' => 31, # Skill above, 0 for none
'X' => 250, # Icon Position in X
'Y' => 289, # Icon Position in Y
'Image' => 'none', # Icon Image, for default icons put ''
'Req_skills' => [560], # Needed skills to open this skill, any quantity
'Req_levels' => [1], # Same as above, but with the levels of each skill
'Desc1' => 'Bulwark of the Ages', # Description 1
'Desc2' => "Upgrade the 'Carapace', character immune to first 3 damage,", # Description 2
'Desc3' => "and raise a few chance to block all damages.", # Description 3
}
end
#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  Esta classe executa o processamento da tela de habilidades. Por conveniência
# dos processos em comum, as habilidades são tratdas como [Itens].
#==============================================================================
class Scene_Skill_Tree < Scene_ItemBase
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização do processo
  #--------------------------------------------------------------------------
  def start
    super
    #p sprintf(@actor.id.to_s)
    if @actor.id > 7 || @actor.id == 3 then
        #msgbox("Talent Tree only available for M6!")
        $game_message.add("Talent Tree only available for M6!")
        @talent_tree_available = false
      return
    else
      @talent_tree_available = true
    end
    
    create_actor_window
    create_windows
    create_tree
    create_images
    create_variables
  end
  #--------------------------------------------------------------------------
  # * Criação das Janelas
  #--------------------------------------------------------------------------
  def create_windows
    
    @info_window = Sk_Tree_Window.new
    @dummy = []
    
    
    for n in 0...Actor[@actor.id][0]['Tree_Images'].size
      @dummy[n] = Window_Base.new(0, 0, Graphics.width, Graphics.height - Win_Size)
      @dummy[n].opacity = Opacity
      @dummy[n].opacity = 0 unless n == 0
    end
    @info_skill = Sk_Descri_Window.new(0, Graphics.height - Win_Size, Graphics.width, Win_Size)
    @info_window.refresh(@actor, 0)
    @info_skill.refresh(@actor.id, 1)
    @info_skill.opacity = Opacity
    @confirm = Window_Skill_Confirm.new # inicialização do menu de confirmação
    @confirm.set_handler(:use_skill, method(:determine_item))
    @confirm.set_handler(:use_point, method(:command_use_point))
    @confirm.set_handler(:return_window, method(:command_return))
    @confirm.close
    @confirm.active = false
    @actor_window = Window_MenuActor_Tree.new
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
    @actor_window.z = 201
  end
  #--------------------------------------------------------------------------
  # * Criação de habilidades
  #--------------------------------------------------------------------------
  def create_tree
    
    @skills_icons = []
    
    for n in 1...Actor[@actor.id].size
      @skills_icons[n] = Sprite.new
      @skills_icons[n].bitmap = Cache.skill_tree(Actor[@actor.id][n]['Image'])
      @skills_icons[n].x = Actor[@actor.id][n]['X']
      @skills_icons[n].y = Actor[@actor.id][n]['Y']
      @skills_icons[n].z = 199
      @skills_icons[n].opacity = 150 if $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] == 0
    end
    @skills_icons.each_index {|n| @skills_icons[n].opacity = 0 if Actor[@actor.id][n]['Tree'] != 1 && n != 0}
  end
  #--------------------------------------------------------------------------
  # * Criação de Imagens
  #--------------------------------------------------------------------------
  def create_images
    
    @cursor = Sprite.new
    @cursor.bitmap = Cache.skill_tree(Cursor)
    @actor_image = Sprite.new
    @actor_image.bitmap = Cache.skill_tree(Actor_Select)
    @actor_image.z = 200
    @actor_image.opacity = 0
    @background_image = Array.new
    
    for n in 0...Actor[@actor.id][0]['Tree_Images'].size
      @background_image[n] = Sprite.new
      @background_image[n].bitmap = Cache.skill_tree(Actor[@actor.id][0]['Tree_Images'][n])
    end
    @cursor.z = 300
    @background_image.each_index {|n| @background_image[n].opacity = 0 unless n == 0}
  end
  #--------------------------------------------------------------------------
  # * Criação das Variáveis
  #--------------------------------------------------------------------------
  def create_variables
    
    
    @goto_x = 0
    @goto_y = 0
    @tree = 0
    @phase = 1
    @count = 15
    @skill_selected = 0
    
    Actor[@actor.id].each{|n| @phase = 0 if n['Tree'] == 2}
    move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
  end
  #--------------------------------------------------------------------------
  # * Atualização do Processo
  #--------------------------------------------------------------------------
  def update
    
    
    super
    return if @actor_window.active
    @actor_image.opacity = 0
    unless @confirm.close?
      if Input.repeat?(:B)
        @confirm.close
        @confirm.active = false
      end
      return
    end
    if @goto_x != @cursor.x || @goto_y != @cursor.y
      cursor_move 
      return
    end
    if @count < 15
      update_tree_opacity(@tree)
      return
    end
    case @phase
    when 0
      update_tree
    when 1
      update_skills
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da árvore
  #--------------------------------------------------------------------------
  def update_tree
    return_scene if Input.repeat?(:B)
    if Input.repeat?(:RIGHT)
      if @tree + 1 == Actor[@actor.id][0]['Tree_Shift'].size
        @tree = 0
      else
        @tree += 1
      end
      @count = 0
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:LEFT)
      if @tree - 1 < 0
        @tree = Actor[@actor.id][0]['Tree_Shift'].size - 1
      else
        @tree -= 1
      end
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
      @count = 0
    elsif Input.repeat?(:UP)
      if @tree - 1 < 0
        @tree = Actor[@actor.id][0]['Tree_Shift'].size - 1
      else
        @tree -= 1
      end
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
      @count = 0
    elsif Input.repeat?(:DOWN)
      if @tree + 1 == Actor[@actor.id][0]['Tree_Shift'].size
        @tree = 0
      else
        @tree += 1
      end
      @count = 0
      @info_window.contents_opacity = 0
      @info_window.refresh(@actor, @tree)
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:C)
      @phase = 1
      n = 0
      n += 1 until Actor[@actor.id][n]['Tree'] == @tree + 1
      @skill_selected = n
      @info_skill.refresh(@actor.id, @skill_selected)
      move_to_cursor(Actor[@actor.id][n]['X'], Actor[@actor.id][n]['Y'])
    end
  end
  #--------------------------------------------------------------------------
  # * Comando de usar um skill point
  #--------------------------------------------------------------------------
  def command_use_point
    if $game_actors[@actor.id].skill_tree[0] == 0 || confirm_skill_add
      Sound.play_buzzer
      @confirm.close
      @confirm.active = false
    else
      @skills_icons[@skill_selected].opacity = 255
      $game_actors[@actor.id].skill_tree[0] -= 1
      $game_actors[@actor.id].lose_jp(Actor[@actor.id][@skill_selected]['JP'])
      $game_actors[@actor.id].skill_mult[Actor[@actor.id][@skill_selected]['Skill_id']] += Actor[@actor.id][@skill_selected]['Multiply']
      $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] += 1
      $game_actors[@actor.id].learn_skill(Actor[@actor.id][@skill_selected]['Skill_id'])
      @info_window.refresh(@actor, @tree)
      Audio.se_play("Audio/SE/Skill3",75,100)
      @confirm.close
      @confirm.active = false
      if $game_switches[19] # achievement available?
        #-------------------------------------------------------------------------------      
        # Trophic: Markspony
        #-------------------------------------------------------------------------------
          earn_trophic = true
          for i in 546..561
            if !$game_actors[@actor.id].skill_learned?(i) && !$ACH_markspony
              earn_trophic = false
              break
            end
          end
          
          if earn_trophic && !$ACH_markspony
            $ACH_markspony = true
            GameJolt.award_trophy("53491")
            p sprintf("Achievement unlock - markspony")
            $game_system.earn_achievement(:markspony)
          end
        #-------------------------------------------------------------------------------      
        # Trophic: Elementalist
        #-------------------------------------------------------------------------------  
          earn_trophic = true
          for i in 563..582
            next if i == 567 || i == 571 || i == 577 || i == 581 
            if !$game_actors[@actor.id].skill_learned?(i) && !$ACH_elementalist
              earn_trophic = false
              break
            end
          end
          
          if earn_trophic && !$ACH_elementalist
            $ACH_elementalist = true
            GameJolt.award_trophy("53485") 
            p sprintf("Achievement unlock - elementalist")
            $game_system.earn_achievement(:elementalist)
          end
        #---------------------------------------------------
      end
    end
  end
  
   
  #--------------------------------------------------------------------------
  # * Comando de retorno
  #--------------------------------------------------------------------------
  def command_return
    @confirm.close
  end
  #--------------------------------------------------------------------------
  # * Atualização de habilidades
  #--------------------------------------------------------------------------
  def update_skills
    if Input.trigger?(:B)
      Sound.play_cancel
      @phase = 1
      Actor[@actor.id].each{|n| @phase = 0 if n['Tree'] == 2}
      return_scene if @phase == 1
      move_to_cursor(Actor[@actor.id][0]['Tree_Shift'][@tree][0], Actor[@actor.id][0]['Tree_Shift'][@tree][1])
    elsif Input.repeat?(:RIGHT)
      unless Actor[@actor.id][@skill_selected]['Right'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Right']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:LEFT)
      unless Actor[@actor.id][@skill_selected]['Left'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Left']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:UP)
      unless Actor[@actor.id][@skill_selected]['Up'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Up']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:DOWN)
      unless Actor[@actor.id][@skill_selected]['Down'] == 0
        @skill_selected = Actor[@actor.id][@skill_selected]['Down']
        @info_skill.refresh(@actor.id, @skill_selected)
        move_to_cursor(Actor[@actor.id][@skill_selected]['X'], Actor[@actor.id][@skill_selected]['Y'])
      end
    elsif Input.repeat?(:C)
      @confirm.open
      @confirm.active = true
    end
  end
  #--------------------------------------------------------------------------
  # * Atualização da opacidade da Skill Tree
  #--------------------------------------------------------------------------
  def update_tree_opacity(tree)
    @count += 1
    @info_window.contents_opacity += 20
    @background_image.each_index {|n| @background_image[n].opacity -= 20 unless n == @tree}
    @background_image.each_index {|n| @background_image[n].opacity += 20 if n == @tree}
    @skills_icons.each_index {|n| @skills_icons[n].opacity -= 10 if Actor[@actor.id][n]['Tree'] != @tree + 1 && n != 0}
    @skills_icons.each_index {|n| @skills_icons[n].opacity += 10 if Actor[@actor.id][n]['Tree'] == @tree + 1 && n != 0}
    @skills_icons.each_index {|n| @skills_icons[n].opacity -= 10 if n != 0 && $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] > 0 && Actor[@actor.id][n]['Tree'] != @tree + 1}
    @skills_icons.each_index {|n| @skills_icons[n].opacity += 10 if n != 0 && $game_actors[@actor.id].skill_tree[Actor[@actor.id][n]['Skill_id']] > 0 && Actor[@actor.id][n]['Tree'] == @tree + 1}
  end
  #--------------------------------------------------------------------------
  # * Cálculo da posição do cursor
  #--------------------------------------------------------------------------
  def move_to_cursor(x, y)
    Sound.play_cursor
    @goto_x = x + Cursor_X
    @goto_y = y + Cursor_Y
    @speed_x = (@goto_x - @cursor.x)/ 10
    @speed_y = (@goto_y - @cursor.y)/ 10
  end
  #--------------------------------------------------------------------------
  # * Atualização da posição do cursor
  #--------------------------------------------------------------------------
  def cursor_move
    if (@cursor.x - @goto_x).abs >= 10
      @cursor.x += @speed_x
    elsif (@cursor.x - @goto_x).abs != 0
      @cursor.x -= (@cursor.x - @goto_x)
    end
    if (@cursor.y - @goto_y).abs >= 10
      @cursor.y += @speed_y
    elsif (@cursor.y - @goto_y).abs != 0
      @cursor.y -= (@cursor.y - @goto_y)
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição das informações do item selecionado
  #--------------------------------------------------------------------------
  def item
    $data_skills[Actor[@actor.id][@skill_selected]['Skill_id']]
  end
  #--------------------------------------------------------------------------
  # * Usando um item
  #--------------------------------------------------------------------------
  def use_item
    super
    @actor_window.open
  end
  #--------------------------------------------------------------------------
  # * Definição do item
  #--------------------------------------------------------------------------
  def determine_item
    if item.for_friend? && $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] > 0
      show_sub_window(@actor_window)
      @confirm.close
      @confirm.active = false
      @actor_image.opacity = 255
      @actor_image.x = 0
      @actor_image.x += Graphics.width - @actor_window.width if cursor_left?
      @actor_window.select_for_item(item)
    else
      @confirm.close
      @confirm.active = false
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de cursor na coluna da esquerda
  #--------------------------------------------------------------------------
  def cursor_left?
    @cursor.x < Graphics.width/2
  end
  #--------------------------------------------------------------------------
  # * Ativação da janela do item
  #--------------------------------------------------------------------------
  def activate_item_window
  end
  #--------------------------------------------------------------------------
  # * Confirmação se adicionará um ponto
  #--------------------------------------------------------------------------
  def confirm_skill_add
    
    req_event = Actor[@actor.id][@skill_selected]['event']
    
    if !req_event.nil?
      return false unless $game_config.configs.include?(req_event)
    end
    
    return true if $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] == Actor[@actor.id][@skill_selected]['Maxlevel']
    return true if $game_actors[@actor.id].level < Actor[@actor.id][@skill_selected]['Level'] + $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Skill_id']] * Actor[@actor.id][@skill_selected]['Level_Add']    
    return true if $game_actors[@actor.id].jp(@actor.class_id) <= Actor[@actor.id][@skill_selected]['JP']
    return false if Actor[@actor.id][@skill_selected]['Req_skills'].empty?
    
    
    for n in 0...Actor[@actor.id][@skill_selected]['Req_skills'].size
      return true if $game_actors[@actor.id].skill_tree[Actor[@actor.id][@skill_selected]['Req_skills'][n]] < Actor[@actor.id][@skill_selected]['Req_levels'][n]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Finalização do processo
  #--------------------------------------------------------------------------
  def terminate
    super
    @background_image.each{|n| n.bitmap.dispose; n.dispose}
    @actor_image.bitmap.dispose
    @actor_image.dispose
    @skills_icons.each{|n| n.bitmap.dispose unless n == nil; n.dispose unless n == nil}
    @cursor.bitmap.dispose
    @cursor.dispose
  end 
  #--------------------------------------------------------------------------
  # * retorna a cena anterior
  #--------------------------------------------------------------------------
  def return_scene
    Sound.play_cancel
    super
  end
end
#==============================================================================
# ** Sk_Tree_Window
#------------------------------------------------------------------------------
#  Esta janela exibe os pontos das habilidades
#==============================================================================
class Sk_Tree_Window < Window_Base
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.z = 200
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def refresh(actor, tree)
    contents.clear
    tree += 1
    act = Actor[actor.id]
    contents.font.size = Font_Skills + 8
    contents.font.name = Font_Name unless Font_Name.empty?
    draw_text(Text_X, Text_Y, 300, 40, Text + actor.skill_tree[0].to_s + " / " + actor.skill_tree.sum.to_s, 0)
    draw_text(Text_X2, Text_Y2, 300, 40, Text2 + actor.jp(actor.class_id).to_s, 0)
    contents.font.size = Font_Skills
    for n in 1...Actor[actor.id].size
      if tree == act[n]['Tree']
        draw_icon($data_skills[act[n]['Skill_id']].icon_index, act[n]['X'], act[n]['Y']) if act[n]['Image'].empty?
        draw_text(act[n]['X'] + Corr_X, act[n]['Y'] + Corr_Y, 120, 30, $game_actors[actor.id].skill_tree[act[n]['Skill_id']].to_s + "/" + act[n]['Maxlevel'].to_s, 0)
      end
    end
    reset_font_settings
  end
end
#==============================================================================
# ** Sk_Descri_Window
#------------------------------------------------------------------------------
#  Esta janela exibe as informações das habilidades
#==============================================================================
class Sk_Descri_Window < Window_Base
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y+15, width, height)
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def refresh(actor_id, skill)
    contents.clear
    contents.font.size = Font_Help
    contents.font.name = Font_Name unless Font_Name.empty?
    draw_text(0, 0, self.width, line_height, Actor[actor_id][skill]['Desc1'], 0)
    draw_text(0, line_height, self.width, line_height, Actor[actor_id][skill]['Desc2'], 0)
    draw_text(0, line_height*2, self.width, line_height, Actor[actor_id][skill]['Desc3'], 0)
    reset_font_settings
  end
end
#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  Esta classe gerencia os heróis. Ela é utilizada internamente pela classe
# Game_Actors ($game_actors). A instância desta classe é referenciada
# pela classe Game_Party ($game_party).
#==============================================================================
class Game_Actor < Game_Battler
alias :lune_sk_initialize :initialize
alias :lune_sk_level_up :level_up
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_accessor :skill_tree                  # Nome
  attr_accessor :skill_mult
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     actor_id : ID do herói
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    lune_sk_initialize(actor_id)
    @skill_tree = Array.new($data_skills.size + 1, 0)
    @skill_mult = Array.new($data_skills.size + 1, 0)
    
  end
  #--------------------------------------------------------------------------
  # * Aumento de nível
  #--------------------------------------------------------------------------
  def level_up
    lune_sk_level_up
    @point_got = [] if @point_got == nil
    
    if Lune_Skill_Tree::Add_Skill_pt
      for i in COMP::POINT_TABLE
        if @level >= i && !@point_got[i]
          @point_got[i] = true
          @skill_tree[0] += 1
        end
      end
    end
  end
end
#==============================================================================
# ** Window_Skill_Confirm
#------------------------------------------------------------------------------
#  Esta janela exibe a confirmação da janela de skills
#==============================================================================
class Window_Skill_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.z = 9999
    self.x = (Graphics.width / 2) - (window_width / 2)
    self.y = Graphics.height / 2
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Aquisição da largura da janela
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Criação da lista de comandos
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
  end
  #--------------------------------------------------------------------------
  # * Adição dos comandos principais
  #--------------------------------------------------------------------------
  def add_main_commands
    #add_command(Lune_Skill_Tree::Bot1,   :use_skill,   true) if Lune_Skill_Tree::Bot1
    add_command(Lune_Skill_Tree::Bot2,  :use_point,  true)
    add_command(Lune_Skill_Tree::Bot3,  :return_window,  true)
  end
end
#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  Este modulo carrega cada gráfico, cria um objeto de Bitmap e retém ele.
# Para acelerar o carregamento e preservar memória, este módulo matém o
# objeto de Bitmap em uma Hash interna, permitindo que retorne objetos
# pré-existentes quando mesmo Bitmap é Requirementsido novamente.
#==============================================================================
module Cache
  #--------------------------------------------------------------------------
  # * Carregamento dos gráficos de animação
  #     filename : nome do arquivo
  #     hue      : informações da alteração de tonalidade
  #--------------------------------------------------------------------------
  def self.skill_tree(filename)
    load_bitmap("Graphics/Skill_Tree/", filename)
  end
end
#==============================================================================
# ** Window_MenuActor_Tree
#------------------------------------------------------------------------------
#  Esta janela é utilizada para selecionar os herois para as habilidades.
#==============================================================================
class Window_MenuActor_Tree < Window_MenuActor
include Lune_Skill_Tree
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize
    super
    self.opacity = Opacity
  end
end
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Um interpretador para executar os comandos de evento. Esta classe é usada
# internamente pelas classes Game_Map, Game_Troop e Game_Event.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Adicionar pontos para o personagem
  #--------------------------------------------------------------------------
  def add_tree_points(actor_id, points)
    $game_actors[actor_id].skill_tree[0] += points
  end
end
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  Esta classe gerencia os battlers. Controla a adição de sprites e ações 
# dos lutadores durante o combate.
# É usada como a superclasse das classes Game_Enemy e Game_Actor.
#==============================================================================
class Game_Battler < Game_BattlerBase
alias :item_rai_lune_effect :item_effect_apply
  #--------------------------------------------------------------------------
  # * Cálculo de dano
  #     user : usuário
  #     item : habilidade/item
  #--------------------------------------------------------------------------
#  def make_damage_value(user, item)
#    value = item.damage.eval(user, self, $game_variables)
#    value *= item_element_rate(user, item)
#    value *= pdr if item.physical?
#    value *= mdr if item.magical?
#    value *= rec if item.damage.recover?
#    value = apply_critical(value) if @result.critical
#    value = apply_variance(value, item.damage.variance)
#    value = apply_guard(value)
#    value += (value * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    
    
#    @result.make_damage(value.to_i, item)
#  end
  #--------------------------------------------------------------------------
  # * Aplicar efeito do uso habilidades/itens
  #     user   : usuário
  #     item   : habilidade/item
  #     effect : efeito
  #--------------------------------------------------------------------------
  def item_effect_apply(user, item, effect)
    @old_value1 = effect.value1
    @old_value2 = effect.value2
    effect.value1 += (effect.value1 * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    effect.value2 += (effect.value2 * $game_actors[user.id].skill_mult[item.id])/100 unless user.enemy?
    item_rai_lune_effect(user, item, effect)
    effect.value1 = @old_value1 unless user.enemy?
    effect.value2 = @old_value2 unless user.enemy?
  end
end
class Scene_Menu < Scene_MenuBase
  
  alias_method  :talenttree_personal_ok, :on_personal_ok
  def on_personal_ok
    talenttree_personal_ok
    if(@command_window.current_symbol == :talent_tree)
      SceneManager.call(Scene_Skill_Tree)
    end
  end
end
#==============================================================================
# ** Arrays
#------------------------------------------------------------------------------
# Novo método para somar os valores dentro da array
#==============================================================================
class Array
  def sum
    a = 0
    for n in 0...size
      a += self[n]
    end
    return a
  end
end
