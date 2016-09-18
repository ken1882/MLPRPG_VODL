class Scene_Map < Scene_Base
  
  def start 
    super
    SceneManager.clear
    $game_player.straighten
    $game_map.refresh
    $game_message.visible = false
     create_spriteset
     create_all_windows
     create_fog
     @menu_calling = false
   end
   
   def create_fog
     @fog = Plane.new
     @fog.bitmap = Cache.picture("fog")
     @fog.opacity = 0
     @fog2 = Plane.new
     @fog2.bitmap = Cache.picture("fog")
     @fog2.opacity = 0
     @fog.blend_type = 1
     @fog2.blend_type = 2
   end
   
   def update
     super 
     $game_map.update(true)
     $game_player.update
     $game_timer.update
     @spriteset.update
     if @fog == nil then create_fog() end
       
     update_scene if scene_change_ok?
     
     if $game_switches[1] then
       if @fog.opacity!= 150 then
         @fog.opacity += 2
         @fog2.opacity += 2
       end
       @fog.ox+=1
       @fog2.ox=@fog.ox/2
       @fog.oy+=1
       @fog2.oy=@fog.oy/2
       
     else
        @fog.opacity = 0
        @fog2.opacity = 0
        @fog.ox = 0 
        @fog.oy = 0
        @fog2.ox = 0 
        @fog2.oy = 0
        @fog = nil
      end
    end
end
     