#===============================================================================
# * PONY::Hud
#-------------------------------------------------------------------------------
#   Hud settings
#===============================================================================
module PONY::Hud
  
  LayoutFilename     = "Hud_Outline"
  LeadLayoutFilename = "Hud_Outline_Lead"
  FaceFilename       = "HudFace_"
  
  HudSize	          = [170, 64]
  ContentBitmapSize = [200, 70]
  
  HPBarRect   = Rect.new(59, 25, 100, 4)
  
  EPBarRect   = Rect.new(61, 34, 92, 4)
  
  FaceHudRect = Rect.new(0, 0, 62, 62)
  FaceSrcRect = Rect.new(0, 0, 68, 68)
  
  NameRect    = Rect.new(58, 4, 102, 18)
  
  StatRect    = Rect.new(60, 40, 200, 24)
  
  FaceTimer   = 60
  FaceIdle    = 0
  FaceCombat  = 1
  FaceAttack  = 2
  FaceInjured = 3
  FaceDying   = 4
  FaceKO      = 5
  
end
