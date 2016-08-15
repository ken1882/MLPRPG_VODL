class Game_Character
    
    def ori_move_straight(d, turn_ok = true)
      @move_succeed = passable?(@x, @y, d)
      if @move_succeed
        set_direction(d)
        @x = $game_map.round_x_with_direction(@x, d)
        @y = $game_map.round_y_with_direction(@y, d)
        @real_x = $game_map.x_with_direction(@x, reverse_dir(d))
        @real_y = $game_map.y_with_direction(@y, reverse_dir(d))
        increase_steps
      elsif turn_ok
        set_direction(d)
        check_event_trigger_touch_front
      end
      
      $game_player.followers.move
    end
    #=============================================================================
    #   Move Down
    #=============================================================================
    def move_down
      for i in 0...8
        @move_poll += [[2,true]]
      end
    end
    #=============================================================================
    #   Move Left
    #=============================================================================
    def move_left
      for i in 0...8
       @move_poll += [[4,true]]
      end
    end
    #=============================================================================
    #   Move Right
    #=============================================================================
    def move_right
      for i in 0...8
        @move_poll += [[6,true]]
      end
    end
    #=============================================================================
    #   Move Up
    #=============================================================================
    def move_up
      for i in 0...8
        @move_poll += [[8,true]]
      end
    end
    
    def near_position(x,y)
      (@x - x).abs <= 0.6 && (@y - y).abs <= 0.6
    end
    
    def return_position_info
        $game_message.add( "(" + self.x.to_s + "," + self.y.to_s + ")" )
    end
    
    def encode(x,y)
      return (x*1000+y).to_i
    end
    
    def decode( n , type)
        return n.to_i/1000.to_i if type == 1
        return n.to_i%1000
    end
    
    def clear_map
      
      dir = [2,4,6,8]
      
      for i in 0..$game_map.width
        for j in 0..$game_map.height
            for c in 0...4
              if $game_map.passable?(i,j,dir[c])
                  $game_map.data[i,j,2] = 893
                end
                
            end
        end
      end
      
    end
    
    def h(from,to) #predict move cost
        dx1 = (decode(from,1) - decode(to,1))
        dx2 = (decode(@x,1) - decode(to,1))
        dy1 = (decode(from,2) - decode(to,2))
        dy2 = (decode(@y,2) - decode(to,2))
        #Cross
        return  (dx1.abs + dy1.abs)*10  + (dx1*dy2 - dx2*dy1).abs*0.1
    end
    
    def merge_sort(array,low,hi,mid,goal,cost)
      pl = low
      pi = low
      pr = mid+1
      temp = []
      while pl <= mid && pi<=hi
        if array[pr] == nil
          temp[pi] = array[pl]
          pl+=1
        elsif h(array[pl],goal) + cost[ array[pl] ] <= h(array[pr],goal) + cost[ array[pr] ]
          temp[pi] = array[pl]
          pl+=1
        else
          temp[pi] = array[pr]
          pr+=1
        end
        pi+=1
      end
      
        if pl > mid
          for i in pr..hi
            temp[pi] = array[i]
            pi+=1
          end
        else
          for i in pl..mid
            temp[pl] = array[i]
            pi+=1
          end
        end
        
        for i in low..hi
          array[i] = temp[i]
        end
    end
    
    #partition
    
    def partition(array,low,hi,goal,cost)
      if low < hi
        mid = (low +hi)/2.to_i
        partition(array,low,mid,goal,cost)
        partition(array,mid+1,hi,goal,cost)
        merge_sort(array,low,hi,mid,goal,cost)
      end
    end
    
        
    
    def move_to_position(goalx,goaly,haste = false,draw_arrow = false)
          clear_map if draw_arrow
          
          vis = []
          
          playerX = (@x - @x.to_i).abs < 0.500 ? @x.to_i : @x.to_i + 1
          playerY = (@y - @y.to_i).abs < 0.500 ? @y.to_i : @y.to_i + 1 
          
          self.moveto(playerX,playerY)
          
          goalx = (goalx - goalx.to_i).abs < 0.500 ? goalx.to_i : goalx.to_i + 1
          goaly = (goaly - goaly.to_i).abs < 0.500 ? goaly.to_i : goaly.to_i + 1
          
          puts "(#{self}): #{playerX},#{playerY} -> (#{goalx},#{goaly})"
          
          for i in 0...1000
            vis[i] = []
          end
          
          queue = []
          node = []
          move_dir = []
          tox = [0,-1,1,0]
          toy = [1,0,0,-1]
          dir = [2,4,6,8]
          goal = encode(goalx,goaly)
          cost = []
          spend = 1
          cost[encode(playerX,playerY)] = spend
          vis[playerX][playerY] = true
          found = false
          queue.push(encode(playerX,playerY))
          
          @path_finding = true
          
          while !queue.empty? && !found
            curx = decode(queue[0],1)
            cury = decode(queue[0],2)
            
            if queue[0] == goal
              node[goal] = goal
              found = true
              break
            end
            
            queue.shift #pop first element
            spend  += 1

            for i in 0...4
              break if found
              nex = (curx + tox[i]).to_i
              ney = (cury + toy[i]).to_i
              
              #==========================================
              # Check passable
              #==========================================
              if $game_map.passable?(nex,ney,dir[i]) && !vis[nex][ney] && !$game_map.over_edge?(nex,ney)
                
                event_blocked = false
                for event_id in 1..$game_map.events.size
                  next if $game_map.events[event_id].nil?
                  if !$game_map.events[event_id].through
                   if $game_map.events[event_id].x == nex && $game_map.events[event_id].y == ney
                     event_blocked = true
                     break
                   end
                  end
                end
                next if event_blocked
                
                vis[nex][ney] = true
                
                found = true if (nex == goalx && ney == goaly)
                node[encode(nex,ney)] = encode(curx,cury)
                move_dir[encode(nex,ney)] = dir[i] 
                
                queue.push(encode(nex,ney))
                #==========================================
                # A*
                #==========================================
                gn = (Math.sqrt( (nex-playerX)*(nex-playerX) + (ney-playerY)*(ney-playerY)) * 10).to_i
                
                case $game_variables[17] 
                when 1
                  cost[encode(nex,ney)] = gn + (ney-goaly).abs * 20
                when 2
                  cost[encode(nex,ney)] = gn + (nex-goalx).abs * 20
                when 3
                  cost[encode(nex,ney)] = (gn + spend * 2 + ((playerX-nex).abs + (playerY-ney).abs) * 2).to_i
                else
                  cost[encode(nex,ney)] = gn.to_i
                end
                
                #==========================================
                # Merge Sort
                #==========================================
                  partition(queue,0,queue.length-1,goal,cost)
                #======================================
                # Draw search arrow
                #=======================================
                if draw_arrow
                  $game_map.data[nex,ney,2] = 887 + dir[i].to_i/2 
                  $game_map.interpreter.wait(1)
                end
                #puts "Next:#{nex},#{ney}"
                
              end # passable
            end #for i in 0...4 
          end # while !queue.empty?
          
          if found #track path
            curp = encode(goalx,goaly)
            path = []
            go_dir = []
            path.push(curp)
            while node[curp]
              path.push(node[curp])
              go_dir.push(move_dir[curp])
              curp = node[curp]
              break if curp == node[curp]
            end
            path = path.reverse
            go_dir = go_dir.reverse
            memory_speed = @move_speed
            
            for i in 0...path.size()
              curx = decode(path[i],1)
              cury = decode(path[i],2)
              dir_id = 887 + go_dir[i].to_i/2
              
              #@move_speed = haste ? 12 : 5
              wait_time = haste ? 3 : 9
              #$game_map.interpreter.wait(wait_time)
              case go_dir[i]
              when 2
                cout_dir = "↓"
                self.move_down
              when 4
                cout_dir = "←"
                self.move_left
              when 6
                cout_dir = "→"
                self.move_right
              when 8
                cout_dir = "↑"
                self.move_up
              else
                cout_dir = "O"
              end #case
              
              #if !self.is_a?(Game_Follower)
              #  $game_player.followers.each do |follower|
              #    follower.chase_preceding_character
              #  end
              #end
              
            end #for i in 0...path.size
            
            #p sprintf("Step:%d",path.size() - 1 )
            #@move_speed = memory_speed
            
            #self.moveto(goalx,goaly) if !near_position(goalx,goaly)
          else
            p sprintf("Can't reach distination")
          end
          
          @path_finding = false
          return found ? true : false
    end
    
end
