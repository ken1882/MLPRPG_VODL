#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  Sperated form original effectus script for better readability
#==============================================================================
class Game_Event < Game_Character
  #----------------------------------------------------------------------------
  # * Update sprite formation
  #----------------------------------------------------------------------------
  def update_effectus_sprite
    @balloon_id > 0
    effectus_original_update if active
      
    unless $game_temp.effectus_sprites[@id]
      $game_temp.effectus_sprites[@id] = 
      Sprite_Character.new(SceneManager.scene.spriteset.viewport1, self)
    end
    
    $game_temp.effectus_sprites[@id].update
    if $game_temp.effectus_sprites[@id].animation?
      unless @effectus_wait_for_animation
        @effectus_wait_for_animation = true
        unless $game_map.effectus_hard_events.include?(self)
          $game_map.effectus_hard_events << self
        end
      end # unless wait for animation
    else
      if @effectus_wait_for_animation
        @effectus_wait_for_animation = nil
        unless @effectus_always_update
          if $game_map.effectus_hard_events.include?(self)
            $game_map.effectus_hard_events.delete(self)
          end
        end # unless always update
      end # if wait for animation
    end # if animationing
    
  end
  #----------------------------------------------------------------------------
  # * update route formation
  #----------------------------------------------------------------------------
  def update_effectus_route
    effectus_original_update if (@effectus_always_update && active) ||
                                      @move_route_forcing
    unless @effectus_always_update
      if @move_route_forcing
        unless @effectus_wait_for_move_route_forcing
          @effectus_wait_for_move_route_forcing = true
          unless $game_map.effectus_hard_events.include?(self)
            $game_map.effectus_hard_events << self
          end
        end
      else
        if @effectus_wait_for_move_route_forcing
          @effectus_wait_for_move_route_forcing = nil
          if $game_map.effectus_hard_events.include?(self)
            $game_map.effectus_hard_events.delete(self)
          end
        end
      end
    end
    
    if $game_temp.effectus_sprites[@id]
      $game_temp.effectus_sprites[@id].dispose
      $game_temp.effectus_sprites.delete(@id)
    end
  end
  #----------------------------------------------------------------------------
  # * Event position occupation
  #----------------------------------------------------------------------------
  def update_position_registeration
    $game_map.effectus_event_pos[@y * $game_map.width + @x] << self
    @effectus_last_x = @x
    @effectus_last_y = @y
    @effectus_position_registered = true    
  end
  #----------------------------------------------------------------------------
  # * Move to another position cache 
  #----------------------------------------------------------------------------
  def update_position_moved
    events = $game_map.effectus_event_pos
    width = $game_map.width
    events[@y * width + @x] << events[@effectus_last_y * width + @effectus_last_x].delete(self)
    if @effectus_tile
      tiles = $game_map.effectus_etile_pos
      tiles[@y * width + @x] << 
      tiles[@effectus_last_y * width + @effectus_last_x].delete(self)
    end
    @effectus_last_x = @x
    @effectus_last_y = @y
  end
  #----------------------------------------------------------------------------
  def effectus_moved?
    @x != @effectus_last_x || @y != @effectus_last_y
  end
  
end
