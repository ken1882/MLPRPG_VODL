#===============================================================================
# Script: Equip Upgrade Scene
# Author: Selchar
#===============================================================================
=begin
This script script is an extention of my Equip Leveling Base.  It creates a
scene allowing you to upgrade your equipment for a cost.  You designate what
equips can be upgraded, and by how far in the Equip Leveling Base script.

To call the EquipUpgrade Scene, use the following as a scriptcall.

SceneManager.call(Scene_EquipUpgrade)

=end
module TH_Instance
  module Scene_EquipUpgrade
    #Message to display to select the item window, similar to buy/sell/etc...
    Vocab = "Upgrade"
    
    #Message to display when no item is selected, as in you enter the scene with
    #no items at all.
    #No_Selected_Item = "Have anything for me to see?"
    No_Selected_Item = "Let's see what we can hammering :)"
    #Help Message displayed on items you can upgrade.  Followed by the upgrade
    #price and currency symbol.
    #Selected_Item = "We can upgrade this item for you for "
    
    Selected_Item = "Upgrade this item will cost  :"
    
    #Help Message displayed on items that have full charge already.
    Can_Not_Upgrade = "This item is already in peak condition!"
    
    #Sound Effect played upon successful item upgrade.
    #     SE_Name, Volume, Pitch
    SE = ['Hammer',100,100]
    
    #Upgrade price = Purchase Price, which is twice the selling price
    #Price_Mod multiplies the purchase price.  Default 0.5
    Price_Mod = 0.5
    
    #Controls what stats are shown and in what order.
    # 0 -> Max Hp | 1 -> Max Mp
    # 2 -> Attack | 3 -> Defense
    # 4 -> Magic  | 5 -> Magic Defense
    # 6 -> Agility| 7 -> Luck
    #Window_Params = [0,1,2,3,4,5,6,7] #Shows everything in order
    Window_Params = [0,1,2,3,4,5,6,7] #Shows offensive stats first, then defensive
  end
end
#===============================================================================
# Rest of the Script
#===============================================================================
$imported = {} if $imported.nil?
$imported[:Sel_Equip_Upgrade_Scene1] = true
unless $imported["TH_InstanceItems"]
  msgbox("Tsukihime's Instance Items not detected,
exiting")
  exit
end
unless $imported[:Sel_Equip_Leveling_Base]
  msgbox("Selchar's Equip Leveling Base was not
detected, Exiting")
  exit
end

#===============================================================================
# Item Selection Window
#===============================================================================
class Window_EquipUpgradeSelect < Window_Selectable
  attr_reader :item_stats_window
  
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  
  def col_max
    return 1
  end
  
  def item_max
    @data ? @data.size : 1
  end
  
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  
  def current_item_enabled?
    enable?(@data[index])
  end
  
  def include?(item)
    !item.is_a?(RPG::Item)
  end
  
  def enable?(item)
    return true if item.is_a?(RPG::EquipItem) && item.can_level && item.level < item.max_level && $game_party.gold >=  item.level_upgrade_price
    return false
  end
  
  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
    end
  end
  
  def update_help
    @help_window.clear
    @item_stats_window.refresh
    unless item
      @help_window.set_text(TH_Instance::Scene_EquipUpgrade::No_Selected_Item)
    else
      if !item.can_level || item.level == item.max_level
        @help_window.set_text(TH_Instance::Scene_EquipUpgrade::Can_Not_Upgrade)
      else
        @help_window.set_text(TH_Instance::Scene_EquipUpgrade::Selected_Item + item.level_upgrade_price.to_s + Vocab.currency_unit)
      end
      @item_stats_window.set_display_stats(item)
    end
  end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end

  def draw_item_name(item, x, y, enabled = true, width = 320)
    super(item, x, y, enabled, width = 320)
  end
  
  def item_stats_window=(window)
    @item_stats_window = window
  end
end

#===============================================================================
# Equip Upgrade Command Window
#===============================================================================
class Window_EquipUpgradeCommand < Window_HorzCommand
  def initialize(window_width)
    @window_width = window_width
    super(0, 0)
  end
  
  def window_width
    @window_width
  end
  
  def col_max
    return 2
  end
  
  def make_command_list
    add_command(TH_Instance::Scene_EquipUpgrade::Vocab, :upgrade)
    add_command(Vocab::ShopCancel, :cancel)
  end
end
#===============================================================================
# Equip Upgrade Stats Window
#===============================================================================
class Window_EquipUpgradeStats < Window_Base
  def initialize
    wh = line_height*(TH_Instance::Scene_EquipUpgrade::Window_Params.size+1)
    super(0, 0, window_width, wh)
    @item = nil
    refresh
  end
  
  def standard_padding
    return 10
  end
  
  def window_width
    return Graphics.width*0.4
  end
  
  def refresh
    contents.clear
    TH_Instance::Scene_EquipUpgrade::Window_Params.each_with_index do |p, i|
      draw_param_name_arrow(4, i, p)
    end
  end
  
  def open
    refresh
    super
  end
  
  def set_display_stats(item)
    refresh
    params = item.params
    TH_Instance::Scene_EquipUpgrade::Window_Params.each_with_index do |p, i|
      draw_current_param(64, i*line_height, params[p])
      if item.can_level && item.level < item.max_level
        new_param = (params[p] * item.instance_mult_lvl_bonus(p)).to_i
        new_param += item.instance_static_lvl_bonus(p)
        draw_new_param(144, i*line_height, params[p], new_param)
      end
    end
  end
  
  def draw_param_name_arrow(x, y, param)
    draw_param_name(x, y*line_height, param)
    draw_right_arrow(x+112, y*line_height)
  end

  def draw_param_name(x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 80, line_height, Vocab::param(param_id))
  end
  
  def draw_current_param(x, y, param)
    change_color(normal_color)
    draw_text(x, y, 32, line_height, param.to_s, 2)
  end
  
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 22, line_height, "→", 1)
  end
  
  def draw_new_param(x, y, old_param, new_param)
    #added :line 243
    if new_param < 20 and new_param > 0 then new_param += 1 end
    change_color(param_change_color(new_param - old_param))
    draw_text(x, y, 32, line_height, new_param, 2)
  end
end
#===============================================================================
# Scene Equip Upgrade
#===============================================================================
class Scene_EquipUpgrade < Scene_ItemBase
  def start
    super
    create_help_window
    create_gold_window
    create_equip_upgrade_stats_window
    create_item_window
    create_command_window
  end

  def create_item_window
    wy = @help_window.y + @help_window.height + @gold_window.height
    ww = (Graphics.width*0.6)
    wh = Graphics.height - wy
    @item_window = Window_EquipUpgradeSelect.new(0, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))

    @item_stats_window.x = @item_window.width
    @item_stats_window.y = @gold_window.y + @gold_window.height
    
    @item_window.category = :item
    
    @item_window.item_stats_window = @item_stats_window
  end
  
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
  end
  
  def create_command_window
    @command_window = Window_EquipUpgradeCommand.new(@gold_window.x)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:upgrade, method(:command_upgrade))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_equip_upgrade_stats_window
    @item_stats_window = Window_EquipUpgradeStats.new
    @item_stats_window.viewport = @viewport
  end
  
  def on_item_ok
    $game_party.lose_gold(item.level_upgrade_price)
    pre_upgrade_corrections
    item.level_up
    @gold_window.refresh
    @item_stats_window.refresh
    on_item_sound
    activate_item_window
  end
  
  def on_item_cancel
    @item_window.unselect
    @item_window.deactivate
    @command_window.activate
    @help_window.set_text('')
    
    @item_stats_window.refresh
  end
  
  def command_upgrade
    @command_window.deactivate
    @item_window.activate
    @item_window.select(0)
  end
  
  def on_item_sound
    RPG::SE.stop
    sound_effect = TH_Instance::Scene_EquipUpgrade::SE
    RPG::SE.new(sound_effect[0], sound_effect[1], sound_effect[2]).play
  end
  
  # Initially for improved compatibility with Exp Leveling, but can be used
  # for others if needed.
  def pre_upgrade_corrections
    item.exp = item.exp_to_level if $imported[:Sel_Equip_Exp_Leveling]
    
  end
end

class RPG::EquipItem
  def level_upgrade_price
    return (self.exp_to_level*10).floor if $imported[:Sel_Equip_Exp_Leveling]
    return (@price * TH_Instance::Scene_EquipUpgrade::Price_Mod).to_i
  end
end