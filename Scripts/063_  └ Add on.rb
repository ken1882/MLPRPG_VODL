#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Gold
  #--------------------------------------------------------------------------
  def gold
    BlockChain.account_balance(Vocab::Player)
  end
  #--------------------------------------------------------------------------
  # * Increase Gold
  #--------------------------------------------------------------------------
  def gain_gold(amount, opp = Vocab::Coinbase, info = '')
    return if amount == 0
    source   = amount < 0 ? Vocab::Player : opp
    receiver = amount > 0 ? Vocab::Player : opp
    BlockChain.bits_transaction(amount.abs, source, receiver, info)
    
    info = sprintf("Party has &s βits: %s", amount < 0 ? 'lost': 'gained', amount)
    SceneManager.display_info(info)
  end
  #--------------------------------------------------------------------------
  # * Decrease Gold
  #--------------------------------------------------------------------------
  def lose_gold(amount, receiver = Vocab::Coinbase, info = '')
    gain_gold(-amount, receiver, info)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def item_number(item)
    container = item_container(item.class)
    if item && !SceneManager.scene.initialized?
      container[item.id] = BlockChain.item_amount(Vocab::Player, item)
      container.delete(item.id) if container[item.id] == 0
    end
    container ? container[item.id] || 0 : 0
  end
  #--------------------------------------------------------------------------
  # * Increase/Decrease Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  alias gain_item_origin gain_item
  def gain_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '')
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number  = [[last_number + amount, 0].max, max_item_number(item)].min
    container.delete(item.id) if new_number == 0
    discard_members_equip(item, -new_number) if include_equip && new_number < 0
    return unless last_number != new_number
    
    
    # source is who pay the bits, thus source will gain the item
    source   = amount > 0 ? Vocab::Player : opp
    receiver = amount < 0 ? Vocab::Player : opp
    BlockChain.item_transaction(item, amount.abs, source, receiver, info)
    container[item.id] = new_number
    container.delete(item.id) if container[item.id] == 0
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def lose_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '')
    gain_item(item, -amount, true, opp, info)  if include_equip
    gain_item(item, -amount, false, opp, info) if !include_equip
  end
  
end
