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
    process_translation
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_dndsubs
    groups = [$data_items, $data_weapons, $data_armors, $data_skills,$data_states, $data_enemies, $data_actors]
    infos  = ["Load Items", "Load Weaopns", "Load Armors", "Load Skills", "Load States", "Load NPCs", "Prepare your ponies"]
    debug_print "load note tags"
    
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
  #--------------------------------------------------------------------------
  # * Change visible text to translated one
  #--------------------------------------------------------------------------
  #tag: transalte
  def self.process_translation
    #translate_actors
    #translate_classes
    translate_items
    translate_weapons
    translate_armors
    translate_skills
    translate_terms
    translate_states
  end
  #--------------------------------------------------------------------------
  def self.translate_items
    path = Vocab.GetDictPath(:item)
    path += "items.ini"
    return unless File.exist?(path)
    n = $data_items.size
    n.times do |i|
      name = FileManager.load_ini("Name", i.to_s, path).purify
      desc = FileManager.load_ini("Desc", i.to_s, path).purify
      $data_items[i].name        = name if name.size > 0
      $data_items[i].description = desc if desc.size > 0
    end
  end
  #--------------------------------------------------------------------------
  def self.translate_weapons
    path = Vocab.GetDictPath(:weapon)
    path += "weapons.ini"
    return unless File.exist?(path)
    n = $data_weapons.size
    n.times do |i|
      name = FileManager.load_ini("Name", i.to_s, path).purify
      desc = FileManager.load_ini("Desc", i.to_s, path).purify
      $data_weapons[i].name        = name if name.size > 0
      $data_weapons[i].description = desc if desc.size > 0
    end
  end
  #--------------------------------------------------------------------------
  def self.translate_armors
    path = Vocab.GetDictPath(:armor)
    path += "armors.ini"
    return unless File.exist?(path)
    n = $data_armors.size
    n.times do |i|
      name = FileManager.load_ini("Name", i.to_s, path).purify
      desc = FileManager.load_ini("Desc", i.to_s, path).purify
      $data_armors[i].name        = name if name.size > 0
      $data_armors[i].description = desc if desc.size > 0
    end
  end
  #--------------------------------------------------------------------------
  def self.translate_skills
    path = Vocab.GetDictPath(:skill)
    path += "skills.ini"
    return unless File.exist?(path)
    n = $data_skills.size
    n.times do |i|
      name = FileManager.load_ini("Name", i.to_s, path).purify
      desc = FileManager.load_ini("Desc", i.to_s, path).purify
      $data_skills[i].name        = name if name.size > 0
      $data_skills[i].description = desc if desc.size > 0
    end
  end
  #--------------------------------------------------------------------------
  def self.translate_states
    path = Vocab.GetDictPath(:state)
    path += "states.ini"
    return unless File.exist?(path)
    n = $data_items.size
    n.times do |i|
      name = FileManager.load_ini("Name", i.to_s, path).purify
      desc = FileManager.load_ini("Desc", i.to_s, path).purify
      $data_states[i].name        = name if name.size > 0
      $data_states[i].description = desc if desc.size > 0
    end
  end
  #--------------------------------------------------------------------------
  def self.translate_terms
    path = Vocab.GetDictPath(:term)
    path += "terms.ini"
    return unless File.exist?(path)
    groups = ["Basic","Command","Param","Etype", "Stype"]
    ref    = [$data_system.terms.basic, $data_system.terms.commands,
              $data_system.terms.params, $data_system.terms.etypes,
              $data_system.skill_types]
              
    groups.each_with_index do |group, i|
      n = ref[i].size
      n.times do |j|
        str = FileManager.load_ini(group, j.to_s, path).purify
        next if str.size == 0
        ref[i][j] = str
      end
    end
    
  end
  #------------------------------
end # DataManager
