#==============================================================================
#    Remove Quest from Default Categories [Patch for Quest Journal v. 1.0.3]
#    Version: 1.0.0
#    Author: modern algebra (rmrk.net)
#    Date: October 24, 2015
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Description:
#
#    This patch allows you to specify that some quests should ONLY show up in
#   the custom categories to which they belong, and not in the default :all, 
#   :active, :complete, and :failed categories.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Instructions:
# 
#    Paste this script into the Script Editor below the Quest Journal but above 
#  Main.
#
#    To specify that a quest should only show up in custom categories, include
#  :only in its custom categories array. For example, if you have a custom 
#  :towns category and you only want the quest to show up in that and not in
#  the :active and :all categories, then you would put the following when
#  setting the quest up:
#
#      q[:custom_categories] = [:only, :towns]
#
#  You can set more than one custom category as well. Please note that if you 
#  do not set at least one custom category though, then putting :only in a 
#  quest's custom categories array will make it invisible and inaccessible.
#==============================================================================
#==============================================================================
# ** Game_Quests
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Summary of Changes:
#    overwritten method - include?
#==============================================================================
class Game_Quests
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Include?
  #    determines whether to include a particular quest depending on list type
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def include?(quest_id, list_type = :all)
    return false if !revealed?(quest_id)
    return @data[quest_id].custom_categories.include?(list_type) if @data[quest_id].custom_categories.include?(:only)
    case list_type
    when :all then true
    when :complete, :failed, :active then @data[quest_id].status?(list_type)
    else
      @data[quest_id].custom_categories.include?(list_type)
    end
  end
end
