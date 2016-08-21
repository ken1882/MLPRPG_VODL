=begin
CSCA Currency System
version: 1.0.0 (Released: February 17, 2013)
Created by: Casper Gaming (http://www.caspergaming.com/)

Compatibility:
Made for RPGVXAce
IMPORTANT: ALL CSCA Scripts should be compatible with each other unless
otherwise noted.
May require a compatibility patch to work well with certain CSCA scripts.
Place this script BELOW all other CSCA Scripts.

FFEATURES
Creates a currency system that allows you to easily set up and use as many
currencies as your game needs.

SETUP
Set up required. Instructions below.

CREDIT:
Free to use in noncommercial games if credit is given to:
Casper Gaming (http://www.caspergaming.com/)

To use in a commercial game, please purchase a license here:
http://www.caspergaming.com/licenses.html

TERMS:
http://www.caspergaming.com/terms_of_use.html
=end
module CSCA
  module CURRENCY
    CURRENCIES = []
#==============================================================================
# ** Important Script Calls
#==============================================================================
# All script calls use the currency symbol to reference a currency.
#------------------------------------------------------------------------------
# switch_currency(currency)
# Used to change the current currency to [currency].
#
# get_current_currency
# Returns the current currency's symbol. For use in event conditional branches.
#
# exchange_currency(currency1, currency2, amount)
# Exchanges the [amount] of [currency1] for [currency2]. Takes into consideration
# currency values. For example if 100 of currency 1 (value of 1), for
# currency 2 (value of 2), the result will be 200 of currency 2 gained.
#
# iv_exchange_currency(currency1, currency2, amount1, amount2)
# Exchanges currencies, ignoring their value. Simply removes [amount1] from
# [currency1] and adds [amount2] to [currency2].
#
# gain_currency(currency, amount)
# Gains [amount] of [currency].
#
# lose_currency(currency, amount)
# Loses [amount] of [currency].
#
# discover_currency(currency[, boolean])
# Sets the [currency]'s discovered status to [boolean] (aka true or false).
# Including the boolean parameter is optional; if not specified, true is assumed.
#==============================================================================
# ** Note Tags Guide
#==============================================================================
# <csca moneypouch>
# This tag goes in an item's note box. When this item is selected from the item
# menu, it will open a new window with all the discovered currencies and amounts
# listed.
#
# <csca_currency: x>
# This tag goes in an enemy's note box. This determines which currency the
# enemy drops. Replace x with the currency symbol for the currency you want to
# drop. This tag is required for all enemies.
#
# <csca_currency: x>
# This tag goes in an item's note box. This determines which currency a shop
# will sell the item for if you don't force the shop to use a specific currency.
# Replace x with a currency symbol. This tag is required for all items, weapons,
# and armors.
#==============================================================================
# ** Default Event Command Notes
#==============================================================================
# The change gold event command will only affect the currency in use. To change
# amounts of other currencies, use the script calls above.
#
# You can force a shop to use a specific currency by controlling the variables
# set below. Otherwise, the shop will use whatever currency the item has tagged.
# More information below.
#==============================================================================
# ** Begin Setup
#==============================================================================
    ALLOW_CHANGE = true # Allow player to change currencies from pouch?
    CHANGE_TEXT = "Currency changed to:" # Text to display when changing currency.
    Vocab_ObtainGold = "%s %s found!" # Text shown for battle gold drop. Overwrites Vocab::ObtainGold
    HEADER = "Currency Exchange" # Header text shown at top of Currency Exchange.
    CUR_VAR = 21 # Variable. In game, set to a currency ID to force a shop to only
                # use that currency. Set the variable to a negative number to turn
                # off currency forcing.
    SELL_CUR_VAR = 22 # Variable. In game, set to a currency ID to force a shop to
                # only buy items from the player in that currency. Set the variable
                # to a negative number to turn off sell currency forcing.
    SELL_PERC = 23 # Variable. In game, change this variable to a value between
                # 0-100 to change the shop sellback % to that value.
    #========================
    # CURRENCY SETUP
    #========================
    # EXAMPLE
    #---------
    #CURRENCIES[x] = {      # where the 'x' is the currency id.
    #:name => "Gold",       # The name of the currency. String.
    #:currency_unit => "G", # The currency unit shown next to the amount.
    #:icon => 361,          # The icon associated with the currency.
    #:color => Color.new(207,181,59), # The color of the currency's text in RGBA
    #:amount => 100,        # The amount the player starts with of this currency.
    #:max => 99999999,      # The max amount of this currency the player can have.
    #:value => 1,           # The value of the currency. Lower number = less valuable
    #:discovered => true,   # true/false, determines whether to show the currency to the player.
    #:desc => "Gold is a currency primarily reserved for royalty.", # Short description of the currency.
    #:sym => :g             # Currency symbol. Used in script calls to refer to this currency.
    #}
    
    CURRENCIES[0] = {
    :name => "βits",
    :currency_unit => "β",
    :icon => 361,
    :color => Color.new(207,181,59),
    :amount => 40,
    :max => 99999999,
    :value => 1,
    :discovered => true,
    :desc => "βits is common currency of Equestria.",
    :sym => :b
    }
    
    CURRENCIES[1] = {
    :name => "Hortican Dollar",
    :currency_unit => "H",
    :icon => 2120,
    :color => Color.new(-250,250,0),
    :amount => 399,
    :max => 99999999,
    :value => 2,
    :discovered => true,
    :desc => "The main currency in the cities of Hortica",
    :sym => :h
    }
    
    CURRENCIES[2] = {
    :name => "Gem",
    :currency_unit => "Gems",
    :icon => 828,
    :color => Color.new(136,250,250),
    :amount => 800,
    :max => 100,
    :value => 50,
    :discovered => true,
    :desc => "Gems are very rare in this world it seems",
    :sym => :g
    }
#==============================================================================
# ** End Setup
#==============================================================================
  end
end
$imported = {} if $imported.nil?
$imported["CSCA-CurrencySystem"] = true
#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  Alters the currency unit method and ObtainGold constant.
#Aliases: currency_unit
#==============================================================================
module Vocab
  ObtainGold      = CSCA::CURRENCY::Vocab_ObtainGold
  #--------------------------------------------------------------------------
  # Alias Method; currency_unit
  #--------------------------------------------------------------------------
  class <<self; alias :csca_currency_unit :currency_unit; end
  def self.currency_unit
    return csca_currency_unit if $game_party.current_currency.nil?
    $game_party.current_currency[:currency_unit]
  end
end
#==============================================================================
# ** BattleManager
#------------------------------------------------------------------------------
#  Changes how currency reward is displayed.
#Overwrites: gain_gold
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # Overwrite Method; Gold Acquisition and Display
  #--------------------------------------------------------------------------
  def self.gain_gold
    $game_troop.gold_total.each do |currency_symbol, amount|
      currency = $game_party.get_csca_cs_currency(currency_symbol)
#      text = sprintf(Vocab::ObtainGold, amount, currency[:name])
      $game_message.add('\.' + text)
      $game_party.gain_currency(currency, amount)
    end
    wait_for_message
  end
end
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Addition of simple script call commands for switching/exchanging currencies.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # Switch currencies
  #--------------------------------------------------------------------------
  def switch_currency(sym)
    $game_party.switch_currency(sym)
  end
  #--------------------------------------------------------------------------
  # Get current currency (for use in event cond. branch)
  #--------------------------------------------------------------------------
  def get_current_currency
    $game_party.current_currency[:sym]
  end
  #--------------------------------------------------------------------------
  # Exchange currencies
  #--------------------------------------------------------------------------
  def exchange_currency(currency1, currency2, amount)
    $game_party.exchange_currency(currency1, currency2, amount)
  end
  #--------------------------------------------------------------------------
  # Exchange currencies ignoring currency value
  #--------------------------------------------------------------------------
  def iv_exchange_currency(currency1, currency2, amount1, amount2)
    lose_currency(currency1, amount1)
    gain_currency(currency2, amount2)
  end
  #--------------------------------------------------------------------------
  # Gain currency (any)
  #--------------------------------------------------------------------------
  def gain_currency(sym, amount)
    $game_party.gain_currency($game_party.get_csca_cs_currency(sym), amount)
  end
  #--------------------------------------------------------------------------
  # Lose currency (any)
  #--------------------------------------------------------------------------
  def lose_currency(sym, amount)
    gain_currency(sym, -amount)
  end
  #--------------------------------------------------------------------------
  # Discover currency
  #--------------------------------------------------------------------------
  def discover_currency(sym, b = true)
    $game_party.discover_currency(sym, b)
  end
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  Added ability to handle multiple currencies and switch between currencies.
#Aliases: initialize, max_gold
#Overwrites: gain_gold
#==============================================================================
class Game_Party < Game_Unit
  attr_reader :currencies
  attr_reader :current_currency
  #--------------------------------------------------------------------------
  # Alias Method; initialize
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize
    csca_cs_init
    csca_cs_init_currencies
  end
  #--------------------------------------------------------------------------
  # Alias method; max_gold
  #--------------------------------------------------------------------------
  alias :csca_cs_max_gold :max_gold
  def max_gold
    @current_currency.nil? ? csca_cs_max_gold : @current_currency[:max]
  end
  #--------------------------------------------------------------------------
  # Overwrite method; gain_gold
  #--------------------------------------------------------------------------
  def gain_gold(amount)
    gain_currency(@current_currency, amount)
  end
  #--------------------------------------------------------------------------
  # Initialize all currencies
  #--------------------------------------------------------------------------
  def csca_cs_init_currencies
    @currencies = []
    CSCA::CURRENCY::CURRENCIES.each do |currency|
      @currencies.push currency
    end
    @current_currency = CSCA::CURRENCY::CURRENCIES[0]
  end
  #--------------------------------------------------------------------------
  # Overwrite reader method
  #--------------------------------------------------------------------------
  def gold
    @current_currency[:amount]
  end
  #--------------------------------------------------------------------------
  # Get currency hash
  #--------------------------------------------------------------------------
  def get_csca_cs_currency(key)
    @currencies.each do |currency|
      return currency if currency.has_value?(key)
    end
  end
  #--------------------------------------------------------------------------
  # Switch currency
  #--------------------------------------------------------------------------
  def switch_currency(sym)
    @current_currency = get_csca_cs_currency(sym)
  end
  #--------------------------------------------------------------------------
  # Exchange currency
  #--------------------------------------------------------------------------
  def exchange_currency(sym1, sym2, amount)
    currency1 = get_csca_cs_currency(sym1)
    currency2 = get_csca_cs_currency(sym2)
    gain_currency(currency2,((currency1[:value].to_f/currency2[:value])*amount).to_i)
    lose_currency(currency1, amount)
  end
  #--------------------------------------------------------------------------
  # Discover currency (any)
  #--------------------------------------------------------------------------
  def discover_currency(sym, b = true)
    currency = get_csca_cs_currency(sym)
    currency[:discovered] = b
  end
  #--------------------------------------------------------------------------
  # Gain currency (any)
  #--------------------------------------------------------------------------
  def gain_currency(currency, amount)
    currency[:amount] = [[currency[:amount] + amount, 0].max, max_currency(currency)].min
  end
  #--------------------------------------------------------------------------
  # Lose currency (any)
  #--------------------------------------------------------------------------
  def lose_currency(currency, amount)
    gain_currency(currency, -amount)
  end
  #--------------------------------------------------------------------------
  # Max currency (any)
  #--------------------------------------------------------------------------
  def max_currency(currency)
    return currency[:max]
  end
end
#==============================================================================
# ** Game_Troop
#------------------------------------------------------------------------------
#  Adds up all total of all currencies dropped.
#Overwrites: gold_total
#==============================================================================
class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # Overwrite Method; Get total currency drop.
  #--------------------------------------------------------------------------
  def gold_total
    drops = {}
    for enemy in dead_members
      symbol = enemy.currency_symbol.downcase.to_sym
      unless drops.has_key?(symbol)
        drops[symbol] = 0
      end
      drops[symbol] += enemy.gold
    end
    return drops
  end
end
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  Access the currency symbol.
#Aliases: initialize
#==============================================================================
class Game_Enemy < Game_Battler
  attr_reader :currency_symbol
  #--------------------------------------------------------------------------
  # Alias Method; Initialize
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize(index, enemy_id)
    csca_cs_init(index, enemy_id)
    @currency_symbol = enemy.currency_symbol
  end
end
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Adds colors to currency
#Overwrites: draw_currency_value
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # Overwrite Method; Draw Number with Currency Unit
  #--------------------------------------------------------------------------
  def draw_currency_value(value, unit, x, y, width, currency = $game_party.current_currency)
    cx = text_size(unit).width
    change_color(currency[:color])
    draw_text(x, y, width - cx - 2, line_height, value, 2)
    change_color(system_color)
    draw_text(x, y, width, line_height, unit, 2)
  end
end
#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  Adds icon to gold window. Supports multiple currencies.
#Aliases: initialize, refresh
#Overwrites: value
#==============================================================================
class Window_Gold < Window_Base
  attr_reader :currency
  #--------------------------------------------------------------------------
  # Alias Method; Object Initialization
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize(currency_symbol = nil)
    @currency = currency_symbol == nil ? $game_party.current_currency : $game_party.get_csca_cs_currency(currency_symbol)
    csca_cs_init
  end
  #--------------------------------------------------------------------------
  # Alias Method; Refresh
  #--------------------------------------------------------------------------
  alias :csca_cs_refresh :refresh
  def refresh
    if @currency == $game_party.current_currency
      csca_cs_refresh
    else
      contents.clear
      draw_currency_value(value, currency_unit, 4, 0, contents.width - 8, @currency)
    end
    draw_icon(@currency[:icon], 0, 0)
  end
  #--------------------------------------------------------------------------
  # Get Currency Unit
  #--------------------------------------------------------------------------
  def currency_unit
    @currency[:currency_unit]
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Get Party Gold
  #--------------------------------------------------------------------------
  def value
    @currency[:amount]
  end
  #--------------------------------------------------------------------------
  # Set new currency
  #--------------------------------------------------------------------------
  def set_currency(currency)
    @currency = currency
    refresh
  end
end
#==============================================================================
# ** CSCA_Window_CurrencyChangeNotify
#------------------------------------------------------------------------------
#  Displays currency change
#==============================================================================
class CSCA_Window_CurrencyChangeNotify < Window_Base
  attr_accessor :currency_window
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 250, fitting_height(2))
    update_placement
    refresh
  end
  #--------------------------------------------------------------------------
  # Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text(0, 0, contents.width, line_height, CSCA::CURRENCY::CHANGE_TEXT, 1)
    change_color($game_party.current_currency[:color])
    draw_text(0, line_height, contents.width, line_height, $game_party.current_currency[:name], 1)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update
    if Input.trigger?(:C) || Input.trigger?(:B) || Input.trigger?(:A)
      Sound.play_ok
      hide
      @currency_window.activate
    end
  end
end
#==============================================================================
# ** CSCA_Window_CurrencyDisplay
#------------------------------------------------------------------------------
#  Shows all currencies
#==============================================================================
class CSCA_Window_CurrencyDisplay < Window_Selectable
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @data = []
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.currencies.select {|item| include?(item)}
  end
  #--------------------------------------------------------------------------
  # Include item in list?
  #--------------------------------------------------------------------------
  def include?(item)
    item[:discovered]
  end
  #--------------------------------------------------------------------------
  # Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_currencies(item, rect.x, rect.y)
    end
  end
  #--------------------------------------------------------------------------
  # Draw currency
  #--------------------------------------------------------------------------
  def draw_currencies(currency, x, y)
    draw_icon(currency[:icon], x, y)
    change_color(system_color)
    draw_text(x+24, y, 172, line_height, currency[:name] + ":")
    change_color(currency[:color])
    draw_text(x+24, y, 172, line_height, currency[:amount], 2)
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(item[:desc])
  end
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_help if self.active
  end
end
#==============================================================================
# ** Window_ShopBuy
#------------------------------------------------------------------------------
#  Changes price text based on currency of item.
#Aliases: initialize, price, enable?
#Overwrites: draw_item, money=
#==============================================================================
class Window_ShopBuy < Window_Selectable
  attr_accessor :currency
  attr_accessor :gold_window
  #--------------------------------------------------------------------------
  # Alias Method; Object Initialization
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize(*args)
    csca_cs_init(*args)
    @currency = nil
  end
  #--------------------------------------------------------------------------
  # Alias method; Get Price of Item
  #--------------------------------------------------------------------------
  alias :csca_cs_price :price
  def price(item)
    item_price = csca_cs_price(item)
    return item_price if @currency.nil?
    if item_currency(item) != @currency
      modifier = (item_currency(item)[:value].to_f/@currency[:value])
      item_price *= modifier
    end
    return item_price.to_i
  end
  #--------------------------------------------------------------------------
  # Alias method; Display in Enabled State?
  #--------------------------------------------------------------------------
  alias :csca_cs_enable? :enable?
  def enable?(item)
    csca_cs_enable?(item) && csca_currency_affordable?(item)
  end
  #--------------------------------------------------------------------------
  # Other currency affordable?
  #--------------------------------------------------------------------------
  def csca_currency_affordable?(item)
    price(item) <= get_currency_used(item)[:amount]
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_price(rect, item, 2)
  end
  #--------------------------------------------------------------------------
  # Overwrite method; Make @money infinite to avoid overwriting other methods.
  #--------------------------------------------------------------------------
  def money=(money)
    @money = 999999999999999999
    refresh
  end
  #--------------------------------------------------------------------------
  # Draw item price
  #--------------------------------------------------------------------------
  def draw_price(rect, item, align)
    color = get_currency_used(item)[:color]
    cur_unit = get_currency_used(item)[:currency_unit]
    change_color(color)
    rect.width -= 12
    draw_text(rect, price(item).to_s, align)
    rect.width += 12
    change_color(system_color)
    draw_text(rect, cur_unit, align)
  end
  #--------------------------------------------------------------------------
  # Get item currency
  #--------------------------------------------------------------------------
  def item_currency(item)
    $game_party.get_csca_cs_currency(item.currency_symbol)
  end
  #--------------------------------------------------------------------------
  # Determine currency in use
  #--------------------------------------------------------------------------
  def get_currency_used(item)
    @currency.nil? ? item_currency(item) : @currency
  end
  #--------------------------------------------------------------------------
  # Alias Method; Update Gold Window
  #--------------------------------------------------------------------------
  alias :csca_cs_update_help :update_help
  def update_help
    csca_cs_update_help
    if @gold_window
      @gold_window.set_currency(get_currency_used(@data[index]))
    end
  end
end
#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  Added handling for different currencies
#Aliases: initialize
#==============================================================================
class Window_ShopSell < Window_ItemList
  attr_accessor :gold_window
  attr_reader :currency
  #--------------------------------------------------------------------------
  # Alias Method; Object Initialization
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize(*args)
    csca_cs_init(*args)
    @currency = $game_party.current_currency
  end
  #--------------------------------------------------------------------------
  # Set currency
  #--------------------------------------------------------------------------
  def set_currency(currency)
    @currency = currency
    @gold_window.set_currency(@currency)
  end
end
#==============================================================================
# ** Window_ShopNumber
#------------------------------------------------------------------------------
#  Added handling for multiple currencies.
#Aliases: initialize
#==============================================================================
class Window_ShopNumber < Window_Selectable
  #--------------------------------------------------------------------------
  # Alias Method; Object Initialization
  #--------------------------------------------------------------------------
  alias :csca_cs_init :initialize
  def initialize(*args)
    csca_cs_init(*args)
    @currency = $game_party.current_currency
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Draw Total Price
  #--------------------------------------------------------------------------
  def draw_total_price
    width = contents_width - 8
    draw_currency_value(@price * @number, @currency_unit, 4, price_y, width, @currency)
  end
  #--------------------------------------------------------------------------
  # Set currency
  #--------------------------------------------------------------------------
  def set_currency(currency)
    @currency = currency
    refresh
  end
end
#==============================================================================
# ** Scene_ItemBase
#------------------------------------------------------------------------------
# Special handling for moneypouch item.
#Aliases: use_item
#==============================================================================
class Scene_ItemBase < Scene_MenuBase
  #--------------------------------------------------------------------------
  # Alias Method; Use Item
  #--------------------------------------------------------------------------
  alias :csca_cs_use_item :use_item
  def use_item
    csca_cs_use_item
    check_moneypouch if item.is_a?(RPG::Item)
  end
  #--------------------------------------------------------------------------
  # Open Currency Window
  #--------------------------------------------------------------------------
  def open_currency_window
    @item_window.unselect
    @item_window.close
    @currency_window.show
    @currency_window.activate
  end
  #--------------------------------------------------------------------------
  # Exit Currency Window
  #--------------------------------------------------------------------------
  def exit_currency_window
    @item_window.select_last
    @item_window.open
    @currency_window.hide
    @currency_window.deactivate
  end
  #--------------------------------------------------------------------------
  # Handling if item is moneypouch
  #--------------------------------------------------------------------------
  def check_moneypouch
    if item.csca_money_pouch?
      @currency_window.refresh
      open_currency_window 
    end
  end
end
#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  Creates currency window.
#Aliases: start
#==============================================================================
class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # Alias Method; Start Processing
  #--------------------------------------------------------------------------
  alias :csca_cs_start :start
  def start
    csca_cs_start
    csca_create_currency_window
    csca_create_notification_window
  end
  #--------------------------------------------------------------------------
  # Create Currency Window
  #--------------------------------------------------------------------------
  def csca_create_currency_window
    @currency_window = CSCA_Window_CurrencyDisplay.new(@item_window.x, @item_window.y, @item_window.width, @item_window.height)
    @currency_window.set_handler(:ok,     method(:change_currency))
    @currency_window.set_handler(:cancel, method(:exit_currency_window))
    @currency_window.help_window = @help_window
    @currency_window.hide
  end
  #--------------------------------------------------------------------------
  # Create Notification Window
  #--------------------------------------------------------------------------
  def csca_create_notification_window
    @currency_changed_window = CSCA_Window_CurrencyChangeNotify.new
    @currency_changed_window.currency_window = @currency_window
    @currency_changed_window.hide
  end
  #--------------------------------------------------------------------------
  # Change currency
  #--------------------------------------------------------------------------
  def change_currency
    if CSCA::CURRENCY::ALLOW_CHANGE
      $game_party.switch_currency(@currency_window.item[:sym])
      @currency_changed_window.refresh
      @currency_changed_window.show
    else
      exit_currency_window
    end
  end
end
#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  Adds support for multiple currencies
#Aliases: prepare, create_buy_window, on_buy_ok, create_sell_window,
#         activate_sell_window, on_sell_ok
#Overwrites: do_buy, selling_price, do_sell
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # Alias Method; Prepare
  #--------------------------------------------------------------------------
  alias :csca_cs_prepare :prepare
  def prepare(goods, purchase_only)
    csca_cs_prepare(goods, purchase_only)
    csca_prepare_currency
  end
  #--------------------------------------------------------------------------
  # Prepare Currency
  #--------------------------------------------------------------------------
  def csca_prepare_currency
    @currency = nil
    @sell_currency = $game_party.current_currency
    @currency = $game_party.currencies[$game_variables[CSCA::CURRENCY::CUR_VAR]] unless
      $game_variables[CSCA::CURRENCY::CUR_VAR] < 0
    @sell_currency = $game_party.currencies[$game_variables[CSCA::CURRENCY::SELL_CUR_VAR]] unless
      $game_variables[CSCA::CURRENCY::SELL_CUR_VAR] < 0
  end
  #--------------------------------------------------------------------------
  # Alias Method; set buy window currency
  #--------------------------------------------------------------------------
  alias :csca_cs_buy_window :create_buy_window
  def create_buy_window
    csca_cs_buy_window
    @buy_window.gold_window = @gold_window
  end
  #--------------------------------------------------------------------------
  # Alias method; Create Sell Window
  #--------------------------------------------------------------------------
  alias :csca_cs_sell_window :create_sell_window
  def create_sell_window
    csca_cs_sell_window
    @sell_window.gold_window = @gold_window
  end
  #--------------------------------------------------------------------------
  # Alias Method; Activate Purchase Window
  #--------------------------------------------------------------------------
  alias :csca_cs_activate_buy :activate_buy_window
  def activate_buy_window
    @buy_window.currency = @currency
    csca_cs_activate_buy
  end
  #--------------------------------------------------------------------------
  # Alias Method; Activate Sell Window
  #--------------------------------------------------------------------------
  alias :csca_cs_activate_sell :activate_sell_window
  def activate_sell_window
    csca_cs_activate_sell
    @sell_window.set_currency(@sell_currency)
  end
  #--------------------------------------------------------------------------
  # Alias Method; Buy [OK]
  #--------------------------------------------------------------------------
  alias :csca_cs_buy_ok :on_buy_ok
  def on_buy_ok
    csca_cs_buy_ok
    @number_window.set_currency(@gold_window.currency)
  end
  #--------------------------------------------------------------------------
  # Alias Method; Sell [OK]
  #--------------------------------------------------------------------------
  alias :csca_cs_sell_ok :on_sell_ok
  def on_sell_ok
    @number_window.set_currency(@sell_currency)
    @buy_window.currency = @sell_currency
    csca_cs_sell_ok
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Execute Purchase
  #--------------------------------------------------------------------------
  def do_buy(number)
    $game_party.lose_currency(@gold_window.currency, number * buying_price)
    $game_party.gain_item(@item, number)
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Execute Sale
  #--------------------------------------------------------------------------
  def do_sell(number)
    $game_party.gain_currency(@gold_window.currency, number * selling_price)
    $game_party.lose_item(@item, number)
  end
  #--------------------------------------------------------------------------
  # Overwrite Method; Get Sale Price
  #--------------------------------------------------------------------------
  def selling_price
    (@buy_window.price(@item) * ($game_variables[CSCA::CURRENCY::SELL_PERC].to_f/100)).to_i
  end
end
#==============================================================================
# ** RPG::BaseItem
#------------------------------------------------------------------------------
#  Get currency for items/enemies
#==============================================================================
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # Get currency symbol
  #--------------------------------------------------------------------------
  def currency_symbol
    @note =~ /<csca_currency: (.*)>/i ? $1.to_sym : ""
  end
end
#==============================================================================
# ** RPG::Item
#------------------------------------------------------------------------------
#  Checks for moneypouch note tag.
#==============================================================================
class RPG::Item < RPG::UsableItem
  #--------------------------------------------------------------------------
  # Item is moneypouch?
  #--------------------------------------------------------------------------
  def csca_money_pouch?
    @note =~ /<csca moneypouch>/i
  end
end