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
  attr_reader   :dead_confirm_timer
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias init_chromastal initialize
  def initialize
    @gold = 0
    init_chromastal
    @chromastal = 0.0
    @dead_confirm_timer = 0
    @skillbar = Game_Skillbar.new
    @skillbar.hide
    @encrypted = true
  end
  #--------------------------------------------------------------------------
  # * Consume Items
  #    If the specified object is a consumable item, the number in investory
  #    will be reduced by 1.
  #--------------------------------------------------------------------------
  def consume_item(item)
    lose_item(item, 1, false, nil, nil, false) if item.is_a?(RPG::Item) && item.consumable
  end
  #--------------------------------------------------------------------------
  # * Gold & Max gold
  #--------------------------------------------------------------------------
  def gold(quick_access = true)
    @gold = BlockChain.account_balance(Vocab::Player) if !quick_access
    return @gold
  end
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
    $game_player.popup_info(amount.to_s, nil, PONY::IconID[:bit]) if SceneManager.scene_is?(Scene_Map) && amount > 0
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
    return if BlockChain.node_empty?
    puts "[BlockChain]: Synchronize party container"
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
  def gain_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '', display_info = true)
    decrypt_data
    opp  = Vocab::Coinbase if opp.nil?
    info = '' if info.nil?
    container = item_container(item.class)
    return encrypt_data unless container
    last_number = item_number(item)
    new_number  = [[last_number + amount, -1].max, max_item_number(item)].min
    container.delete(item.id) if new_number == 0
    discard_members_equip(item, -new_number) if include_equip && new_number < 0
    new_number = [new_number, 0].max
    $game_party.skillbar.need_refresh = true
    return encrypt_data unless last_number != new_number
    
    # source is who pay the bits, thus source will gain the item
    source   = amount > 0 ? Vocab::Player : opp
    receiver = amount < 0 ? Vocab::Player : opp
    BlockChain.item_transaction(item, (new_number - last_number).abs, source, receiver, info)
    container[item.id] = new_number
    container.delete(item.id) if container[item.id] == 0
    info = sprintf("Party has %s an item(x%s)", amount < 0 ? 'lost': 'gained', amount.abs)
    SceneManager.display_info(info) if display_info
    #$game_map.need_refresh = true
    $game_party.skillbar.need_refresh = true
    $game_player.popup_info(item.name, nil, item.icon_index) if SceneManager.scene_is?(Scene_Map) && amount > 0
    encrypt_data
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def lose_item(item, amount, include_equip = false, opp = Vocab::Coinbase, info = '', display = true)
    gain_item(item, -amount, true, opp, info, display)  if include_equip
    gain_item(item, -amount, false, opp, info, display) if !include_equip
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
    @battle_members_array[index1], @battle_members_array[index2] = @battle_members_array[index2], @battle_members_array[index1]
    puts "Battler array: #{index1} #{index2} #{@battle_members_array[index1]} #{@battle_members_array[index2]}"
    members[index1].map_char.swap_member(members[index2].map_char)
    members[index1].map_char, members[index2].map_char = members[index2].map_char, members[index1].map_char
    $game_map.need_refresh = true
    swap_order_opt(index1, index2)
    rearrange_actors
    members.each {|member| member.map_char.process_actor_death if member.dead?}
    $game_player.current_target = nil
    SceneManager.immediate_refresh
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
      if !@battle_members_array.include?(member.actor.id)
        @battle_members_array << member.actor.id
      end
      swap_order(0, index)
      puts "recurrence leader: #{all_members[0].name} <=> #{all_members[index].name}"
      break
    end
    $game_player.recurrence_delay = nil
  end
  #--------------------------------------------------------------------------
  # * Make all party member's exp as closer as possible
  #--------------------------------------------------------------------------
  def gain_exp(xp)
    return if xp == 0
    info = sprintf("Party has gained xp: %d", xp)
    SceneManager.display_info(info)
    # Number of pones
    msize  = members.size
    # xp that disputed
    disputed = 0
    # average xp of the party
    xp_avg = 0 
    # average xp for everypony
    xp_gained_avg = (xp / msize).to_i 
    # calculate average xp of the party
    members.each{|member| xp_avg += member.exp}
    xp_avg = (xp_avg / msize).to_i
    # Calculate tandard Deviation of party's xp
    standard_deviation = 0
    members.each do |member|
      standard_deviation += (member.exp - xp_avg) ** 2
    end
    standard_deviation = (Math.sqrt(standard_deviation / msize)).to_f
    # Dispute weighted xp gain
    member_by_min = members.sort{|a, b| a.exp <=> b.exp}
    member_by_min.each do |member|
      standardized  = member.exp - xp_avg
      standardized /= standard_deviation if standard_deviation > 0
      xp_gained     = (xp_gained_avg - standardized * standard_deviation).to_i
      xp_gained = 0 if xp_gained < 0
      xp_gained = (xp - disputed) / 2 if xp_gained > (xp - disputed)
      puts "#{member.name} gained xp: #{xp_gained}"
      disputed += xp_gained
      member.gain_exp(xp_gained)
    end
    # Dispute lefover averagely
    leftover = xp - disputed
    members.each do |member|
      gained = (leftover / msize).to_i
      disputed += gained
      member.gain_exp(gained)
    end
    # Dispute final very very few lefover to leader
    leader.gain_exp(xp - disputed)
  end
  #--------------------------------------------------------------------------
  def gathered?
    members.each do |member|
      next if !member.map_char
      return false if member.map_char.distance_to_character($game_player) > 3
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?(check_only = false)
    return false if !check_only && !$game_system.allow_gameover?
    re = super() && ($game_party.in_battle || members.size > 0)
    @dead_confirm_timer = 0 if @dead_confirm_timer.nil?
    @dead_confirm_timer = re ? @dead_confirm_timer + 1 : 0
    BattleManager.send_flag(in_battle: true) if re
    return re && @dead_confirm_timer > 180
  end
end
