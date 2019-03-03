#==============================================================================
# ** RPG::Event::Page::Condition
#==============================================================================
class RPG::Event::Page::Condition
  
  def code_condition
    @code_condition = [] if @code_condition.nil?
    return @code_condition
  end
  
end