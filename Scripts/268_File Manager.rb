#==============================================================================
# ** FileManager
#------------------------------------------------------------------------------
#  This module is using to change the configs in Game.ini, e.g. sound volume or
#  other settings.
#==============================================================================
module FileManager
  #--------------------------------------------------------------------------
  # * Text wrap for window contents
  #--------------------------------------------------------------------------
  def self.textwrap(full_text = "", line_width = 1)
    return [] if full_text.nil?
    line_width *= 1.3
    text_width = Font.default_size / 2
    text_limit = line_width / text_width
    line_count = (full_text.size + text_limit - 1) / text_limit
    clone_text  = []
    wraped_text = []
    full_text.each_char { |ch| clone_text.push(ch)}
    while clone_text.size > 0
      text = ""
      clone_text.shift if clone_text[0] == ' '
      n = clone_text.size
      for i in 0...n
        ch = clone_text[i]
        text += ch
        break if ch == 10.chr
        break if text.size >= text_limit
      end
      
      processed  = ensure_lines_connected(text, clone_text.drop(text.size))
      clone_text = clone_text.drop(text.size + processed[0])
      text = processed[1]
      wraped_text.push(text)
    end
    
    return wraped_text
  end
  #--------------------------------------------------------------------------
  # *  If line ended in the mid of word, add '-' connect two lines.
  #--------------------------------------------------------------------------
  def self.ensure_lines_connected(text, clone_text)
    return [0, text] if !clone_text[0] || !text[-1]
    return [0, text] if !clone_text[0].match(/^[[:alpha:]]$/)
    return [0, text] if !text[-1].match(/^[[:alpha:]]$/)
    endl_pos = 0
    surplus = ""
    3.times do |i|
      break if clone_text[i].nil?
      surplus += clone_text[i]
      endl_pos = i if clone_text[i] == ' ' || clone_text[i] == 10.chr
    end
    proc_text = endl_pos > 0 ? text + surplus[0...endl_pos] : text + '-'
    return [endl_pos, proc_text]
  end
  #--------------------------------------------------------------------------
  # * Load Game.ini index
  #--------------------------------------------------------------------------
  def self.load_ini(group, target)
    buffer = '\0' * 256
    PONY::API::GetPPString.call(group, target, '', buffer, 256, ".//Game.ini")
    return buffer.strip
  end
  #--------------------------------------------------------------------------
  # * Modify Game.ini index
  #--------------------------------------------------------------------------
  def self.write_ini(group, target, goal)
    PONY::API::WritePPString.call(group, target, goal, ".//Game.ini")
  end # def change ini
end
