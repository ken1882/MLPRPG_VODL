#===============================================================================
# * Falcao Pearl ABS Party HUD Add-On
#
# This add-on display followers HP and MP bars on the current screen
# For logic reasons the bars are displayed only while in battle
# This script take the same colors of the Game Player HUD
#
# Website: http://falcaorgss.wordpress.com/
# Foro: www.makerpalace.com
#
# * Intallation
# Copy and paste the script below Pearl ABS Liquid system, edit module below
# for convenience
#-------------------------------------------------------------------------------
module PartyHud
  
  Pos_X = 0     # Position x on the screen
  Pos_Y = 80   # Position Y on the screen
  
end
class PearlPartyHud < Sprite
  include PearlBars
  def initialize(viewport)
    super(viewport)
    self.bitmap = Bitmap.new(160, 180)
    self.x = PartyHud::Pos_X
    self.y = PartyHud::Pos_Y
    @party = []
    @old_data = {}
    $game_player.followers.each {|f| @party << f.battler if f.visible?}
    refresh_party_hud
    update
  end
  
  def refresh_party_hud
    self.bitmap.clear
    self.bitmap.font.size = 16
    y = 0
    hc = HP_Color ; mc = MP_Color
    @party.each do |battler|                             # w    h
      PearlKernel.draw_hp(self.bitmap, battler, 8, y + 30, 80,  8,  hc, true)
      PearlKernel.draw_mp(self.bitmap, battler, 8, y + 43, 80,  8,  mc)
      @old_data[battler.id] = [battler.hp, battler.mp]
      y += 48
    end
  end
  
  def update
    @party.each {|battler|
    if @old_data[battler.id][0] != battler.hp
      refresh_party_hud 
    elsif @old_data[battler.id][1] != battler.mp
      refresh_party_hud 
    end}
  end
  
  def dispose
    self.bitmap.dispose
    super
  end
  
  def refresh_members
    @party = []
    $game_player.followers.each {|f| @party << f.battler if f.visible?}
    refresh_party_hud
  end
  
end
class Spriteset_Map
  alias falcaopearl_party_create create_pearl_abs_sprites
  def create_pearl_abs_sprites
    @framerr = 0
    falcaopearl_party_create
  end
  
  alias falcaopearl_party_update update_pearl_abs_main_sprites
  def update_pearl_abs_main_sprites
    update_party_hud_sprites
    falcaopearl_party_update
  end
  
  def update_party_hud_sprites
    if $game_player.pearl_menu_call[1] == 1
      dispose_party_hud
      return
    end
    create_party_hud
    #if @framerr == 0
    #  if $game_player.follower_fighting?
    #    create_party_hud
    #  else ; dispose_party_hud
    #  end
    #else
    #  @framerr += 1
    #  @framerr = 0 if @framerr == 10
    #end
    @party_hud.update unless @party_hud.nil?
  end
  
  def create_party_hud
    return if !@party_hud.nil?
    @party_hud = PearlPartyHud.new(@viewport2)
  end
  
  def dispose_party_hud
    return if @party_hud.nil?
    @party_hud.dispose
    @party_hud = nil
  end
  
  def refresh_party_hud
    return if @party_hud.nil?
    @party_hud.refresh_members
  end
  
  
  alias falcaopearl_party_dispose dispose_pearl_main_sprites
  def dispose_pearl_main_sprites
    falcaopearl_party_dispose
    dispose_party_hud
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Refresh Party Hud
  #--------------------------------------------------------------------------
  def refresh_party_hud
    return if @spriteset.nil?
    @spriteset.refresh_party_hud
  end
end
