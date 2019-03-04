#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================
class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 2, width = Graphics.width)
    super(0, 0, width, fitting_height(line_number))
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    text = (text || '')
    if text != @text
      @text = text.dup
      if text.is_a?(Array)
        @text = modify_text
      elsif text_size(text).width > contents.width
        @text = FileManager.textwrap(text, contents.width)
        @text = modify_text
      else
        @text = @text.force_encoding($default_encoding)
      end
      refresh
    end
  end
  #--------------------------------------------------------------------------
  def modify_text
    @text = @text.inject(""){|str, line| str += line + 10.chr}
    @text = @text.force_encoding($default_encoding)
  end
  #--------------------------------------------------------------------------
end
