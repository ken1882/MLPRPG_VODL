class RPG::BaseItem
  
  def has_note_tag?(what)
    !get_note_tags(what).empty?
  end
  
  def get_note_tags(what)
    timings = note.split("\r\n").map{|x| x.split(":")}.keep_if{|x| x[0] == what};
    # this is really inefficient, by the way; optimize it later
    return timings.map{|x| x[1]}
  end
  
  def get_first_note_tag(what)
    temp = get_note_tags(what)
    return nil if !temp
    temp.first
  end
end
class RPG::Actor < RPG::BaseItem
end
class RPG::Class < RPG::BaseItem
end
