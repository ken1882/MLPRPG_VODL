#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_dndsubs load_database; end
  def self.load_database
    $data_notetagged_items = []
    load_database_dndsubs
    load_notetags_dndsubs
  end
  
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_dndsubs
    groups = [$data_items, $data_weapons, $data_armors, $data_skills,$data_states, $data_enemies, $data_actors]
    infos  = ["Load Items", "Load Weaopns", "Load Armors", "Load Skills", "Load States", "Load NPCs", "Prepare your ponies"]
    puts "[Debug]:load note tags"
    
    cnt = 0
    for group in groups
      nload = group.size + 10
      SceneManager.set_loading_phase(infos[cnt], nload)
      cnt += 1
      for obj in group
        SceneManager.update_loading
        next if obj.nil?
        obj.hash_self
        obj.load_notetags_dndsubs
      end
    end
  end
  #------------------------------
end # DataManager
