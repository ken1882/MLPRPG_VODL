=begin
#======================================
#   Path Finding via A* & DP
#======================================

module SETUP
  CUT_LEN = 8
end

class Game_Map
  
    def A_star?
      return $game_switches[5]^1
    end
    
    def encode(x,y)
      return (x*1000+y).to_i
    end
    
    def decode( n , type)
        return n.to_i/1000.to_i if type == 1
        return n.to_i%1000
    end
      
    def clear_map
      tox = [0,-1,1,0]
      toy = [1,0,0,-1]
      dir = [8,6,4,2]
      for i in 0..$game_map.width
        for j in 0..$game_map.height
            for c in 0...4
              curx = i+tox[c]
              cury = j+toy[c]
              if $game_player.passable?(curx,cury,dir[c])
                  $game_map.data[i,j,2] = 893
              end
            end#end c
        end#end j
      end#end i
    end
    
    
    def h(from,to) #predict move cost
        dx1 = (decode(from,1) - decode(to,1))
        dx2 = (decode(@x,1) - decode(to,1))
        dy1 = (decode(from,2) - decode(to,2))
        dy2 = (decode(@y,2) - decode(to,2))
        #Cross
        return  (dx1.abs + dy1.abs)*10  + (dx1*dy2 - dx2*dy1).abs*0.1
    end
    
    def merge(array,low,hi,mid,goal,cost)
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
    def merge_sort(array,low,hi,goal,cost)
      if low < hi
        mid = (low +hi)/2.to_i
        merge_sort(array,low,mid,goal,cost)
        merge_sort(array,mid+1,hi,goal,cost)
        merge(array,low,hi,mid,goal,cost)
      end
    end

    def A_star(goalx,goaly)
          clear_map if $draw_arrow
          
          vis = []
          
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
          cost[encode(@x,@y)] = spend
          vis[@x][@y] = true
          found = false
          queue.push(encode(@x,@y))
          
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
              nex = curx + tox[i]
              ney = cury + toy[i]
              
              #==========================================
              # Check passable
              #==========================================
              if $game_player.passable?(curx,cury,dir[i]) && !vis[nex][ney]
                vis[nex][ney] = true
                found = true if (nex == goalx && ney == goaly)
                node[encode(nex,ney)] = encode(curx,cury)
                move_dir[encode(nex,ney)] = dir[i] 
                
                queue.push(encode(nex,ney))
                #==========================================
                # A*
                #==========================================
                  #is not fake A* ?
                  (Math.sqrt( (nex-goalx)*(nex-goalx) + (ney-goaly)*(ney-goaly) ) * 10)
                  cost[encode(nex,ney)] = gn
                #==========================================
                # Merge Sort
                #==========================================
                  merge_sort(queue,0,queue.length-1,goal,cost)
                #======================================
                #Draw search arrow
                #=======================================
                $game_map.data[nex,ney,2] = 887 + dir[i].to_i/2 if $draw_arrow
                $game_map.interpreter.wait(1) if $draw_arrow
              end
            end              
          end
          
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
            
            if double_a_star? && found
                if @backtrack_path.size < path.size
                path = @backtrack_path
                go_dir = @backtrack_dir
              end
            end            
            
            for i in 0...path.size()
              curx = decode(path[i],1)
              cury = decode(path[i],2)
              dir_id = 887 + go_dir[i].to_i/2
              
              @move_speed = haste ? 12 : 5
              wait_time = haste ? 3 : 9
              $game_map.interpreter.wait(wait_time)
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
              end
              p sprintf("(%d,%d),%s",curx,cury,cout_dir)
            end
            p sprintf("Step:%d",path.size()-1) if found
          else
            p sprintf("Can't reach distination")
          end
          return found ? true : false
    end
    
  
  
  
  
  
  
  
    def area_id(x,y)
      cut = SETUP::CUT_LEN
      area_inline = (width+(cut-1) / cut).to_i
      dx = (x+1)/cut
      dy = (y+1)/cut
            
    end
    
  
    def Run_PathFinding_DP
      
    end
    
  
  end
=end