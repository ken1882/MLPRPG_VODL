# =============================================================================
# TheoAllen - Gameover Choice + Battle Retry
# Version : 2.2
# Contact : www.rpgmakerid.com (or) http://theolized.blogspot.com
# Requester : Darken (RMID) / Agus Widhiantara (FB)
# (This script documentation is written in informal indonesian language)
# =============================================================================
($imported ||= {})[:Theo_GChoice] = true
# =============================================================================
# Change Logs:
# -----------------------------------------------------------------------------
# 2014.08.21 - Compatibility with TSBS (part 2)
# 2014.02.11 - Compatibility with TSBS
# 2013.11.29 - Finished version 2.0
# 2013.02.26 - Finished version 1.0
# =============================================================================
=begin

  Perkenalan :
  Script ini nambah pilihan saat gameover berupa Battle Retry dan kembali ke
  checkpoint terakhir
  
  Cara penggunaan :
  Pasang script ini di bawah material namun di atas main. Jika kamu juga 
  make script TSBS, pasang script ini dibawah implementationnya
  
  Untuk menggunakan checkpoint, gunakan script call :
  
  $game_system.save_checkpoint
  $game_system.load_checkpoint
  
  Dari namanya udah keliatan mana untuk save checkpoint dan mana yang load.
  
  Terms of use :
  Credit gw, TheoAllen. Kalo semisal u bisa ngedit2 script gw trus jadi lebih
  keren, terserah. Ane bebasin. Asal ngga ngeklaim aja. Kalo semisal mau
  dipake buat komersil, jangan lupa, gw dibagi gratisannya.        

=end
# =============================================================================
# Konfigurasi
# =============================================================================
module Theo
  module GC
  # ---------------------------------------------------------------------------
  # Vocab untuk command di dalam window
  # ---------------------------------------------------------------------------
    VocabRetry  = "Battle Retry"      # Untuk battle retry
    VocabCP     = "Last Checkpoint"   # Untuk checkpoint
    VocabLoad   = "Load Saved Game"
    VocabTitle  = "To title"          # Untuk ke title
  # ---------------------------------------------------------------------------
    Width       = 200  # Lebar window gameover choice
  # ---------------------------------------------------------------------------
  end
end
# =============================================================================
# Akhir dari konfigurasi
# =============================================================================
class Game_System
  class CheckPoint
    attr_accessor :x
    attr_accessor :y
    attr_accessor :map_id
    attr_accessor :d
    attr_accessor :dumped_party
    attr_accessor :dumped_actors
    
    def initialize
      @x = $data_system.start_x
      @y = $data_system.start_y
      @map_id = $data_system.start_map_id
      @d = 2
      @dumped_party = nil
      @dumped_actors = {}
    end
  end
  
  attr_reader :checkpoint
  
  alias theo_gchoice_init initialize
  def initialize
    theo_gchoice_init
    @checkpoint = CheckPoint.new
  end
  
  def save_checkpoint
    if $game_party.in_battle
      return 
    end
    checkpoint.x = $game_player.x
    checkpoint.y = $game_player.y
    checkpoint.map_id = $game_map.map_id
    checkpoint.d = $game_player.direction
    checkpoint.dumped_party = copy($game_party) 
    $game_party.members.each do |member|
      checkpoint.dumped_actors[member.id] = copy(member)
    end
  end
  
  def load_checkpoint
    $game_map.setup(checkpoint.map_id)
    $game_player.moveto(checkpoint.x, checkpoint.y)
    $game_player.set_direction(checkpoint.d)
    $game_party = checkpoint.dumped_party if checkpoint.dumped_party
    checkpoint.dumped_actors.each do |id, dump_actor|
      next if dump_actor.nil?
      $game_actors[id] = dump_actor
    end
    SceneManager.clear
    SceneManager.goto(Scene_Map)
    for battler in $game_party.members
      battler.hp += battler.mhp/10
      battler.remove_state(1)
    end
    $game_system.menu_disabled = false
  end
  
end

class Game_Temp
  class Last_Troop
    attr_accessor :id
    attr_accessor :can_lose
    attr_accessor :can_escape
    def initialize
      @id = 0
      @can_lose = false
      @can_escape = true
    end
  end
  
  attr_accessor :dumped_party
  attr_accessor :battle_retry
  attr_reader :dumped_actors
  attr_reader :last_troop
  
  alias theo_gchoice_init initialize
  def initialize
    theo_gchoice_init
    @battle_retry = false
    @last_troop = Last_Troop.new
    @dumped_actors = []
    @dumped_party = nil
  end
end

class Game_Actor < Game_Battler
  
  def save_actor
    $game_temp.dumped_actors[id] = copy(self)
  end
  
  def load_actor
    $game_actors[id] = copy($game_temp.dumped_actors[id])
  end
  
  def save_load_actor
    $game_temp.battle_retry ? load_actor : save_actor
  end
  
end

class Game_Actors
  
  def []=(id, actor)
    @data[id] = actor
  end
  
end

class Game_Party < Game_Unit
  
  def save_party
    $game_temp.dumped_party = copy(self)
  end
  
  def load_party
    $game_party = copy($game_temp.dumped_party)
  end
  
  def save_load_party
    $game_temp.battle_retry ? load_party : save_party
    members.each do |m|
      m.save_load_actor
    end
  end
  
end

class << BattleManager
  
  alias theo_gchoice_setup setup
  def setup(troop_id, can_escape = true, can_lose = false)
    theo_gchoice_setup(troop_id, can_escape, can_lose)
    $game_temp.last_troop.id = troop_id
    $game_temp.last_troop.can_escape = can_escape
    $game_temp.last_troop.can_lose = can_lose
  end
  
  def battle_retry
    troop_id = $game_temp.last_troop.id
    can_escape = $game_temp.last_troop.can_escape
    can_lose = $game_temp.last_troop.can_lose
    theo_gchoice_setup(troop_id, can_escape, can_lose)
    Sound.play_battle_start
    play_battle_bgm
  end
  
  alias theo_gchoice_replay_music replay_bgm_and_bgs
  def replay_bgm_and_bgs
    begin
      theo_gchoice_replay_music
    rescue
      $game_map.autoplay
    end
  end
  
end

class Window_GOChoice < Window_Command
  
  def initialize
    super(0,0)
    update_placement
    self.openness = 0
    activate
  end
  
  def make_command_list
    #add_command(Theo::GC::VocabRetry, :retry)
    add_command(Theo::GC::VocabCP, :checkpoint, $game_system.checkpoint)
    add_command(Theo::GC::VocabLoad, :load)
    add_command(Theo::GC::VocabTitle, :title)
  end
  
  def update_placement
    self.x = (Graphics.width - width)/2
    self.y = (Graphics.height * 1.6 - height) / 2
  end
  
  def window_width
    Theo::GC::Width
  end
  
end

class Scene_Gameover < Scene_Base
  
  alias theo_gchoice_start start
  def start
    theo_gchoice_start
    @command_window = Window_GOChoice.new
    #@command_window.set_handler(:retry, method(:battle_retry)) 
    @command_window.set_handler(:checkpoint, method(:goto_checkpoint))
    @command_window.set_handler(:load, method(:goto_load))
    @command_window.set_handler(:title, method(:goto_title))
    @command_window.open
  end
  
  def battle_retry
#    $game_system.gameover = false ###
    $game_temp.tsbs_compatible = true
    RPG::ME.stop
    BattleManager.battle_retry
    $game_temp.battle_retry = true
    SceneManager.goto(Scene_Battle)
    close_command
  end
  
  def goto_checkpoint
    RPG::ME.stop
    for i in 1...20 do
      if $game_actors[i] then
        $game_actors[i].hp += $game_actors[i].mhp/20 unless $game_actors[i].hp > $game_actors[i].mhp/20
      end
    end
    $game_system.load_checkpoint
    $game_map.autoplay
    close_command
  end
  
  def goto_load
    SceneManager.call(Scene_Load)
  end
  
  def close_command
    @command_window.close
    update_basic until @command_window.close?
  end
  # ----------------------------------------
  # Overwrites
  # ----------------------------------------
  def update
    super
  end
  
end

class Scene_Battle
  
  alias theo_gchoice_post_start post_start
  def post_start
    $game_party.save_load_party
    if $game_temp.battle_retry && $imported[:TSBS]
      recreate_spriteset
      $game_temp.battle_retry = false
    else
      $game_temp.battle_retry = false
    end
    theo_gchoice_post_start
  end
  
  def recreate_spriteset
    @spriteset.dispose
    create_spriteset
    $game_temp.battle_retry = false
  end
  
end

def copy(object)
  Marshal.load(Marshal.dump(object))
end