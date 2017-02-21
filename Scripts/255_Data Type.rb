#===============================================================================
# * Basic Fixnum class
#===============================================================================
class Fixnum
  #----------------------------------------------------------------------------
  # *) Convert to radians
  #----------------------------------------------------------------------------
  def to_rad
    self * Math::PI / 180
  end
  #----------------------------------------------------------------------------
  # *) Convert to boolean
  #----------------------------------------------------------------------------
  def to_bool
    self == 0 ? false : true
  end
  #----------------------------------------------------------------------------
  # *) String for filename
  #----------------------------------------------------------------------------
  def to_fileid(deg)
    n = self
    cnt = 0
    while n > 0
      n /= 10
      cnt += 1
    end
    cnt = [cnt, 1].max
    PONY::ERRNO.raise(:intid_overflow, :exit) if cnt > deg
    return ('0' * (deg - cnt)) + self.to_s
  end
end
#===============================================================================
# * Basic String class
#===============================================================================
class String  
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def delete_at(pos)
    return if pos >= self.size
    self[pos] = ''
  end
end
#===============================================================================
# * Superclass of almost database items
#===============================================================================
class RPG::BaseItem
  #----------------------------------------------------------------------------
  # *) Delete a char at certain position
  #----------------------------------------------------------------------------
  def id_for_filename
    n = @id
    cnt = 0
    while n > 0
      n /= 10
      cnt += 1
    end
    dict = ''
    dict = "Items/"   if self.is_a?(RPG::Item)
    dict = "Weapons/" if self.is_a?(RPG::Weapon)
    dict = "Armors/"  if self.is_a?(RPG::Armor)
    dict = "Skills/"  if self.is_a?(RPG::Skill)
    return sprintf("%s%s%s",dict, '0' * (3 - cnt), @id)
  end
end
#===============================================================================
# * Overwrite the exit method to program-friendly
#===============================================================================
def exit(stat = true)
  SceneManager.scene.fadeout_all rescue nil
  SceneManager.exit
end
