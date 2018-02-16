
#-------------------------------------------------------------------------------
# * Setup Part (Pixel Movement)
#-------------------------------------------------------------------------------
module Pixel_Core
  
  # Auto Update events with tileset graphics?
  Auto_Refresh_Tile_Events = true
  
  # Auto Update range
  TileEvent_Range = 3
  
  # Auto Multiply event commands?
  # (this option will multiply the event commands by 4 if set to true)
  Multiply_Commands = true
  
  # Commands to multiply (ID)
  Commands = [1,2,3,4,5,6,7,8,9,10,11,12,13]
  
  #-----------------------------------------------------------------------------
  # * Constants - Do not modify!
  #-----------------------------------------------------------------------------
  Pixel = 4
  Tile = (1.0 / Pixel)
  Default_Collision_X = 2
  Default_Collision_Y = 2
  Body_Axis = [0.25,0.25,0.5,0.75]
  Bush_Axis = [0.5,0.75]
  Counter_Axis = [0.25,0.25,0.25,0.25]
  Ladder_Axis = [0.25,0.25]
  Pixel_Range = {2=>[0,0.25],4=>[-0.25,0],6=>[0.25,0],8=>[0,-0.25]}
  Tile_Range  = {2=>[0,1],4=>[-1,0],6=>[1,0],8=>[0,-1]}
  Water_Range = {2=>[0,3],4=>[-3,0],6=>[3,0],8=>[0,-3]}
  Trigger_Range = {2=>[0,2],4=>[-2,0],6=>[2,0],8=>[0,-2]}
  Counter_Range = {2=>[0,3],4=>[-3,0],6=>[3,0],8=>[0,-3]}
  Chase_Axis = {2=>[0,1],4=>[1,0],6=>[1,0],8=>[0,1]}
end
#-------------------------------------------------------------------------------
# * Game Map
#-------------------------------------------------------------------------------
class Game_Map
  include Pixel_Core
  attr_reader :pixel_table
  #-------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------
  def pixel_valid?(x, y)
    x >= 0 && x <= @pixel_wm && y >= 0 && y <= @pixel_hm
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  alias kp_referesh_vehicles referesh_vehicles
  def referesh_vehicles
    setup_table
    kp_referesh_vehicles
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def setup_table
    @pixel_table = Table.new(width*Pixel, height*Pixel,6)
    for x in 0...(width*Pixel)
      for y in 0...(height*Pixel)
        @pixel_table[x,y,0] = 1
        @pixel_table[x,y,1] = table_skill_collision(x*Tile,y*Tile)
        @pixel_table[x,y,3] = table_ladder(x*Tile,y*Tile)
        @pixel_table[x,y,4] = table_bush(x*Tile+Bush_Axis[0],y*Tile+Bush_Axis[1])
        @pixel_table[x,y,5] = table_counter(x*Tile+Counter_Axis[0],y*Tile+Counter_Axis[1])
      end
    end
    build_map_collision_table
    @pixel_wm = (width-1)*Pixel
    @pixel_hm = (height-1)*Pixel
  end
  #-------------------------------------------------------------------------------
  def build_map_collision_table
    for x in 0...width
      for y in 0...height
        setup_pixel_collision(x, y, 0)
      end
    end
    File.open("debug.txt", 'w') do |file|
      cnt = 0
      for i in 0...(height*Pixel)
        for j in 0...(width*Pixel)
          file.write("#{@pixel_table[j,i,0]}")
          cnt += 1
          file.write(' ') if cnt % 4 == 0
        end
        file.write(10.chr)
      end
    end
  end
  #-------------------------------------------------------------------------------
  def setup_pixel_collision(x, y, type)
    blocked     = []
    block_rects = [
      Rect.new( 0, 1, 4, 3),
      Rect.new(-3,-1, 3, 4),
      Rect.new( 1,-3, 3, 6),
      Rect.new( 0,-3, 4, 2)
    ]
    px = x * Pixel
    py = y * Pixel
    for i in 0...4
      dir = (i+1) << 1
      blocked.push(!check_layer_passage(x, y, dir))
      if blocked[i]
        setup_pixel_collision_rect(px, py, block_rects[i], type, false)
      end #if blocked
    end # for 1~4
    
    if blocked[1] && blocked[3] # 7
      rect = Rect.new(-3,-3,3,3)
      setup_pixel_collision_rect(px, py, rect, type, false)
    end
    if blocked[0] && blocked[1] # 1
      rect = Rect.new(-3,3,3,1)
      setup_pixel_collision_rect(px, py, rect, type, false)
    end
    
  end
  #-------------------------------------------------------------------------------
  def setup_pixel_collision_rect(px, py, rect, type, passable)
    passable = passable.to_i
    for by in 0...rect.height
      for bx in 0...rect.width
        cx = px + rect.x + bx; cy = py + rect.y + by;
        @pixel_table[cx, cy, type] = passable
      end
    end 
  end
  #-------------------------------------------------------------------------------
  def check_layer_passage(x, y, dir)
    bit = (1 << (dir / 2 - 1)) & 0x0f;
    layered_tiles(x, y).each do |tile_id|
      flag = tileset.flags[tile_id]
      if flag & 0x10 != 0                   # [☆]: No effect on passage
        next         if flag & bit == 0     # [○] : Passable but star
        return false if flag & bit == bit   # [×] : Impassable
      else
        return true  if flag & bit == 0     # [○] : Passable
        return false if flag & bit == bit   # [×] : Impassable
      end
    end
    return false                   
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_player_collision(x,y)
    return 0 unless table_pp((x+Body_Axis[0]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_pp((x+Body_Axis[2]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_pp((x+Body_Axis[0]).to_i,(y+Body_Axis[3]).to_i)
    return 0 unless table_pp((x+Body_Axis[2]).to_i,(y+Body_Axis[3]).to_i)
    return 1
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_skill_collision(x,y)
    return 0 unless table_ps((x+Body_Axis[0]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_ps((x+Body_Axis[2]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_ps((x+Body_Axis[0]).to_i,(y+Body_Axis[3]).to_i)
    return 0 unless table_ps((x+Body_Axis[2]).to_i,(y+Body_Axis[3]).to_i)
    return 1
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def refresh_table(start_x,start_y,end_x,end_y)
    for x in (start_x*Pixel)..(end_x*Pixel)
      for y in (start_y*Pixel)..(end_y*Pixel)
        @pixel_table[x,y,0] = table_pcrf(x*Tile,y*Tile)
        @pixel_table[x,y,1] = table_scrf(x*Tile,y*Tile)
      end
    end
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def refresh_table_px(start_px,start_py,end_px,end_py)
    for x in start_px..end_px
      for y in start_py..end_py
        @pixel_table[x,y,0] = table_pcrf(x*Tile,y*Tile)
        @pixel_table[x,y,1] = table_scrf(x*Tile,y*Tile)
      end
    end
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_pcrf(x,y)
    return 0 unless table_pprf((x+Body_Axis[0]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_pprf((x+Body_Axis[2]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_pprf((x+Body_Axis[0]).to_i,(y+Body_Axis[3]).to_i)
    return 0 unless table_pprf((x+Body_Axis[2]).to_i,(y+Body_Axis[3]).to_i)
    return 1
  end
  def table_scrf(x,y)
    return 0 unless table_psrf((x+Body_Axis[0]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_psrf((x+Body_Axis[2]).to_i,(y+Body_Axis[1]).to_i)
    return 0 unless table_psrf((x+Body_Axis[0]).to_i,(y+Body_Axis[3]).to_i)
    return 0 unless table_psrf((x+Body_Axis[2]).to_i,(y+Body_Axis[3]).to_i)
    return 1
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_p(x,y,bit)
    
    layered_tiles(x,y).each do |tile_id|
      flag = tileset.flags[tile_id]
      
      next if flag & 0x10 != 0
      return true  if flag & bit == 0
      return false if flag & bit == bit
    end
    return false
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_pp(x,y)
    layered_tiles(x,y).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0
      return true if flag & 0x0f == 0
      return false if flag & 0x0f == 0x0f
    end
    return false
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_ps(x,y)
    return true if $game_map.region_id(x,y) == 1
    id_cnt = 0
    layered_tiles(x,y).each do |tile_id|
      flag = tileset.flags[tile_id]
      id_cnt += flag & 0x10
      next if flag & 0x10 != 0
      return true if flag & 0x0400 == 0
      return true if flag & 0x0f == 0
      return false if flag & 0x0f == 0x0f
    end
    return id_cnt == 48
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_pprf(x,y)
    all_tiles(x, y).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0
      return true if flag & 0x0f == 0
      return false if flag & 0x0f == 0x0f
    end
    return false
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_psrf(x,y)
    all_tiles(x,y).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0
      return true if flag & 0x0400 == 0
      return true if flag & 0x0f == 0
      return false if flag & 0x0f == 0x0f
    end
    return false
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_bush(x,y)
    return layered_tiles_flag?(x.to_i, y.to_i, 0x40) ? 1 : 0
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_ladder(x,y)
    return 1 if layered_tiles_flag?(x.to_i,(y+Ladder_Axis[1]).to_i, 0x20)
    return 1 if layered_tiles_flag?((x+Ladder_Axis[0]).to_i, (y+Ladder_Axis[1]).to_i, 0x20)
    return 0
  end
  #-------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------
  def table_counter(x,y)
    return 1 if layered_tiles_flag?(x.to_i,y.to_i, 0x80)
    return 1 if layered_tiles_flag?((x+Counter_Axis[2]).to_i,y.to_i, 0x80)
    return 1 if layered_tiles_flag?(x.to_i,(y+Counter_Axis[3]).to_i, 0x80)
    return 1 if layered_tiles_flag?((x+Counter_Axis[2]).to_i,(y+Counter_Axis[3]).to_i, 0x80)
    return 0
  end
  #-------------------------------------------
end
