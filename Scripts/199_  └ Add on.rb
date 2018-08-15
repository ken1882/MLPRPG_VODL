#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================
class Window_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # * Overwrite: Draw Description
  #--------------------------------------------------------------------------
  def draw_description(x, y)
    desc = FileManager.textwrap(@actor.description, contents.width, contents)
    draw_text_ex(x, y, desc)
  end
end
