#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :chromastal                     # Chromastal mined value
  attr_accessor :skillbar
  attr_reader   :encrypted
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_chromastal initialize
  def initialize
    @gold = PONY.EncryptInt(0)
    init_chromastal
    @chromastal = 0.0
    @skillbar = Game_Skillbar.new
    @skillbar.hide
    @encrypted = true
    @gold = PONY.EncryptInt(0)
  end
  #--------------------------------------------------------------------------
  # * Gold & Max gold
  #--------------------------------------------------------------------------
  def gold(quick_access = true)
    # tag: queued >> security
    #@gold = PONY.EncInt(BlockChain.account_balance(Vocab::Player)) if !quick_access
    @gold = BlockChain.account_balance(Vocab::Player) if !quick_access
    return @gold
  end # queued: gold enctyption!
  #--------------------------------------------------------------------------
  def max_gold; return 10 ** 6; end
  #--------------------------------------------------------------------------  
  # * Mining reward
  #--------------------------------------------------------------------------
  def mining_reward(value)
    @chromastal += value
    if @chromastal >= 1.0
      amount = @chromastal.to_i
      @chromastal -= amount
      gain_item($data_items[42], amount)
    end
  end
  #--------------------------------------------------------------------------
  # * Increase Gold
  #--------------------------------------------------------------------------
  def gain_gold(amount, opp = Vocab::Coinbase, info = '')
    return if amount == 0
    amount   = [max_gold - gold(true), amount].min
    overflow = (gold(true) + amount) > max_gold
    source   = amount < 0 ? Vocab::Player : opp
    receiver = amount > 0 ? Vocab::Player : opp
    BlockChain.bits_transaction(amount.abs, source, receiver, info)
    @gold += amount
    info = sprintf("Party has %s βits: %s%s", amount < 0 ? 'lost': 'gained', amount.abs, overflow ? "(maxium reached)" : "")
    SceneManager.display_info(info)
  end
  #--------------------------------------------------------------------------
  # * Decrease Gold
  #--------------------------------------------------------------------------
  def lose_gold(amount, receiver = Vocab::Coinbase, info = '')
    gain_gold(-amount, receiver, info)
  end
  #--------------------------------------------------------------------------
  # * Overwrite: Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def item_number(item)
    return nil if item.nil?
    container = item_container(item.class)
    container ? container[item.id] || 0 : 0
  end
  #--------------------------------------------------------------------------
  # * Synchronize data with Block Chain
  #--------------------------------------------------------------------------
  def sync_blockchain(item = nil)
    pc = Vocab::Player
    if item.nil?
      data = BlockChain.all_data(pc)
      @items.each do |key, number|
        @items[key] = data[:item][$data_items[key].hashid]
        @items.delete(key) if @items[key] <= 0
      end
      @weapons.each do |key, number|
        @weapons[key] = data[:weapon][$data_weapons[key].hashid]
        @weapons.delete(key) if @weapons[key] <= 0
      end
      @armors.each do |key, number|
        @armors[key] = data[:armor][$data_armors[key].hashid]
        @armors.delete(key) if @armors[key] <= 0
      end
      @gold = data[:gold]
    else
      container = item_container(item.class)
      container[item.id] = BlockChain.item_amount(pc, item)
    end
    encrypt_data
  end
  #--------------------------------------------------------------------------
  # * Increase/Decrease Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  alias gain_item_origin gain_item
  def gain_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '')
    decrypt_data
    container = item_container(item.class)
    return encrypt_data unless container
    last_number = item_number(item)
    new_number  = [[last_number + amount, 0].max, max_item_number(item)].min
    container.delete(item.id) if new_number == 0
    discard_members_equip(item, -new_number) if include_equip && new_number < 0
    return encrypt_data unless last_number != new_number
    
    # source is who pay the bits, thus source will gain the item
    source   = amount > 0 ? Vocab::Player : opp
    receiver = amount < 0 ? Vocab::Player : opp
    BlockChain.item_transaction(item, (new_number - last_number).abs, source, receiver, info)
    container[item.id] = new_number
    container.delete(item.id) if container[item.id] == 0
    info = sprintf("Party has %s an item(x%s)", amount < 0 ? 'lost': 'gained', amount.abs)
    SceneManager.display_info(info)
    #$game_map.need_refresh = true
    $game_party.skillbar.need_refresh = true
    encrypt_data
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def lose_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '')
    gain_item(item, -amount, true, opp, info)  if include_equip
    gain_item(item, -amount, false, opp, info) if !include_equip
  end
  #--------------------------------------------------------------------------
  def encrypt_data
    return # tag: queued >> security
    return if @encrypted
    @items.each do |key, number|
      @items[key] = PONY.EncryptInt(@items[key])
    end
    @weapons.each do |key, number|
      @weapons[key] = PONY.EncryptInt(@weapons[key])
    end
    @armors.each do |key, number|
      @armors[key] = PONY.EncryptInt(@armors[key])
    end
    @gold = PONY.EncryptInt(@gold)
    @encrypted = true
  end
  #--------------------------------------------------------------------------
  def decrypt_data
    return # tag: queued >> security
    return unless @encrypted
    @items.each do |key, number|
      @items[key] = PONY.DecryptInt(@items[key])
    end
    @weapons.each do |key, number|
      @weapons[key] = PONY.DecryptInt(@weapons[key])
    end
    @armors.each do |key, number|
      @armors[key] = PONY.DecryptInt(@armors[key])
    end
    @gold = PONY.DecryptInt(@gold)
    @encrypted = false
  end
  #--------------------------------------------------------------------------
  # * Swap order
  #--------------------------------------------------------------------------
  alias swap_order_opt swap_order
  def swap_order(index1, index2)
    members[index1].map_char.swap_member(members[index2].map_char)
    members[index1].map_char, members[index2].map_char = members[index2].map_char, members[index1].map_char
    $game_map.need_refresh = true
    swap_order_opt(index1, index2)
    members.each {|member| member.map_char.process_actor_death if member.dead?}
    Cache.release_spriteset
  end
  #--------------------------------------------------------------------------
  # * Return usable general items for hotkey usage
  #--------------------------------------------------------------------------
  def get_valid_items
    list = []
    @items.each do |id, number|
      item = $data_items[id]
      list << item if item.for_friend? || item.for_opponent?
    end
    return list
  end
  #--------------------------------------------------------------------------
  # * Change current control character to next alive member
  #--------------------------------------------------------------------------
  def recurrence_leader
    all_members.each_with_index do |member, index|
      next if member.dead?
      next if member == leader
      swap_order(0, index)
      break
    end
    $game_player.recurrence_delay = nil
  end
  #--------------------------------------------------------------------------
end
