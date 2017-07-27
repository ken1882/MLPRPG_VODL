#===============================================================================
# * PONY::Hud
#-------------------------------------------------------------------------------
#   Hud settings
#===============================================================================
module PONY::Hud
  
  LayoutFilename     = "Hud_Outline"
  LeadLayoutFilename = "Hud_Outline_Lead"
  FaceFilename       = "HudFace_"
  
  HudSize	    = [170, 64]
  
  HPBarRect   = Rect.new(59, 21, 100, 4)
  
  EPBarRect   = Rect.new(61, 30, 92, 4)
  
  FaceHudRect = Rect.new(0, 0, 62, 62)
  FaceSrcRect = Rect.new(0, 0, 68, 68)
  
  NameRect    = Rect.new(58, 4, 100, 14)
  
  StatRect    = Rect.new(60, 36, 24 * 4, 24)
  
end
