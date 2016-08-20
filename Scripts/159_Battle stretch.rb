#==============================================================================
# ** TDS Battleback Stretch
#    Ver: 1.0
#------------------------------------------------------------------------------
#  * Description:
#  This script automatically resizes the background images in battle into 
#  the size of the screen.
#------------------------------------------------------------------------------
#  * Features: 
#  Resizes battleback images into the size of the screen.
#------------------------------------------------------------------------------
#  * Instructions:
#  Just put it in your game and enjoy.
#------------------------------------------------------------------------------
#  * Notes:
#  Cutscenes need to be faded in after being skipped and music needs to be
#  replayed after being skipped since they are faded out to allow the creator
#  of the cutscene to arrange things accordingly before the player takes control.
#------------------------------------------------------------------------------
# WARNING:
#
# Do not release, distribute or change my work without my expressed written 
# consent, doing so violates the terms of use of this work.
#
# If you really want to share my work please just post a link to the original
# site.
#
# * Not Knowing English or understanding these terms will not excuse you in any
#   way from the consequenses.
#==============================================================================
# * Import to Global Hash *
#==============================================================================
($imported ||= {})[:TDS_Battleback_Stretch] = true

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Create Battleback 1 (Floor)
  #--------------------------------------------------------------------------
  def create_battleback1
    @back1_sprite = Sprite.new(@viewport1)
    @back1_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    # Get Background Bitmap
    background = battleback1_bitmap
    # Get Screen Size Rect
    screen = Rect.new(0, 0, Graphics.width, Graphics.height)
    # Stretch Battleback
    @back1_sprite.bitmap.stretch_blt(screen, background, background.rect)
    #battleback1_bitmap
    @back1_sprite.z = 0
    center_sprite(@back1_sprite)
  end
  #--------------------------------------------------------------------------
  # * Create Battleback 2 (Wall)
  #--------------------------------------------------------------------------
  def create_battleback2
    @back2_sprite = Sprite.new(@viewport1)
    @back2_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height) 
    # Get Background Bitmap
    background = battleback2_bitmap
    # Get Screen Size Rect
    screen = Rect.new(0, 0, Graphics.width, Graphics.height)
    # Stretch Battleback
    @back1_sprite.bitmap.stretch_blt(screen, background, background.rect)    
    @back2_sprite.z = 1
    center_sprite(@back2_sprite)
  end
end