=begin
(1) 顯示文字
$game_message.add(text)

(2) 更變對話框位置
A. 位置
$game_system.message_position = 數字  ( 0=下 / 1=中 / 2=上 )
B. 透明度
$game_system.message_frame = 數字 ( 0=半透明 / 1=透明 )
(3)等待
@wait_count = 等待幀數
$game_map.interpreter.wait($trap_speed2)
(4) 暫時消除事件
$game_map.events[事件編號].erase
(5) 呼叫公共事件
$game_temp.common_event_id = 公共事件編號
(6) 開關操作
$game_switches[變量編號] = true或false
(7) 變數操作
$game_variables[變數編號] = 變數數值
(8) 計時器操作
$game_system.timer = 計時器的時間（秒）
(9) 增減金幣
$game_party.gain_gold(金錢數量)
(10) 增減物品
A. 增加物品
$game_party.gain_item(物品編號,增加數量)
B. 減少物品
$game_party.lose_item(物品編號,減少數量)
(11) 增減武器
A. 增加武器
$game_party.gain_weapon(武器編號,增加數量)
B. 減少武器
$game_party.lose_weapon(武器編號,減少數量)
(12) 增減防具
A. 增加防具
$game_party.gain_armor(防具編號,增加數量)
B. 減少防具
$game_party.lose_armor(防具編號,減少數量)
(13) 替換隊員
A. 加入隊員
$game_party.add_actor(加入角色編號)
B. 隊員離隊
$game_party.remove_actor(離隊角色編號)
C. 初始化隊員
$game_party[角色編號].setup(角色編號)
(14) 變更視窗外觀
$game_system.windowskin_name = "視窗面板文件的名稱"
( 視窗面板文件都放在 windowskin 資料夾底下 )
(15) 變更禁止存檔
$game_system.save_disabled = true或false
(16) 變更禁止選單
$game_system.menu_disabled = true或false
(17) 變更禁止遇敵
$game_system.encounter_disabled = true或false



(1) 設置事件位置
$game_map.events[事件編號].moveto(地圖x坐標,地圖y坐標)
(2) 畫面捲動
$game_map.start_scroll(捲動方向，捲動距離，捲動速度)
( 捲動速度建議 1 ~ 6 )
(3) 顯示動畫
A. 顯示在主角上
$game_player.animation_id = 動畫編號
B. 顯示在事件上
$game_map.events[事件編號].animation_id = 動畫編號
(4) 變更透明狀態
$game_player.transparent ＝ true或false
(5) 等待移動結束
@move_route_waiting = true
(6) 準備轉變 
Graphics.freeze
(7) 執行漸變
Graphics.transition(時間, "Graphics/Transitions/漸變圖形名稱")
(7) 變更畫面色彩
$game_screen.start_tone_change(Tone.new(紅色調,綠色調,藍色調,灰度),時間)
(8) 畫面閃爍
$game_screen.start_flash(Color.new(紅色調,綠色調,藍色調,強度),時間)
(9) 畫面震動
$game_screen.start_shake(震動強度，震動速度，震動時間)
( 強度和速度建議為 1 ~  9 )
(10) 顯示圖片
$game_screen.pictures[圖片編號].show("圖片檔名", 原點, 畫面x坐標, 畫面y坐標, x軸放大率, y軸放大率, 不透明度, 顯示方式)
※ 圖片要放在 Graphic / Picture 資料夾裡面 
※ 原點若設為 0 ，則座標是左上表示；若原點設為 1 ，則座標是中心表示 
※ x軸放大率、y軸放大率，設為100是正常大小
※ 顯示方式，0正常，1加法，2減法
(11) 移動圖片
$game_screen.pictures[圖片編號].move(移動時間, 原點, 畫面x坐標, 畫面y坐標, x軸放大率, y軸放大率, 不透明度, 顯示方式)
(同顯示圖片，隨著你指定的移動時間，漸變成這個指令中的新設定)
(12) 旋轉圖片
$game_screen.pictures[圖片編號].rotate(旋轉速度)
※旋轉速度 = 每1幀的旋轉角度 ，正數是順時針轉，負數是逆時針轉
(13) 圖片消失
$game_screen.pictures[圖片編號].erase
(14) 天候設置
$game_screen.weather(類型, 強度, 時間)
類型0 = 沒有，1 = 雨，2 = 風，3 = 雪，強度為1到9。
(15) 播放BGM
Audio.bgm_play("Audio/BGM/音樂文件名", 音量, 頻率)
※ 音量、頻率，預設為100
(16) 播放BGS
Audio.bgs_play("Audio/BGS/音樂文件名", 音量, 頻率)
(17) 記憶BGM/BGS
$game_system.bgm_memorize
$game_system.bgs_memorize
(18) 還原BGM/BGS
$game_system.bgm_restore
$game_system.bgs_restore
(19) 播放SE
Audio.se_play("Audio/SE/音樂文件名", 音量, 頻率)
(20) 播放ME
Audio.me_play("Audio/ME/音樂文件名", 音量, 頻率)
(21) 停止SE
Audio.se_stop


遠景 圖片指定$game_map.panorama_name = "全景圖形檔名" (指定的是Graphics/Panorama中的檔名)
遠景 色調 $game_map.panorama_hue = 數字（0-255 預設 0 ）

迷霧 圖片指定  $game_map.fog_name = "霧圖形的名字"  (指定的是Graphics/Fog中的檔名)
迷霧 色調  $game_map.fog_hue = 數字（0-255 預設 0 ）
迷霧 透明度  $game_map.fog_opacity = 數字（0-255）
迷霧 混合模式 $game_map.fog_blend_type = 數字（0普通，1加法，2減法）
迷霧 放大倍率 $game_map.fog_zoom = 數字 ( 預設 100 )
迷霧 X軸 移動速度  $game_map.fog_sx = 數字
迷霧 Y軸 移動速度  $game_map.fog_sy = 數字

戰鬥背景 圖片指定  ( 改的是所在地圖屬性 )  $game_map.battleback_name = "戰鬥背景圖片名"  
戰鬥背景 圖片指定  ( 改的是戰鬥畫面屬性 ) $game_temp.battleback_name = "戰鬥背景圖片名"
指定的都是(指定的是Graphics/Battleback中的檔名)

 變更霧的色調
$game_map.start_fog_tone_change(Tone.new(紅色調,綠色調,藍色調,灰度), 時間)


 變更霧的不透明度
$game_map.start_fog_opacity_change(不透明度, 時間)
( 此為漸進式)




 


 若要等待移動結束，就把這段加在後面
@move_route_waiting=true







角色 HP   $game_actors[角色編號].hp 
角色 SP   $game_actors[角色編號].sp 
角色 最大 HP $game_actors[角色編號].maxhp 
角色 最大 SP $game_actors[角色編號].maxsp 
角色 經驗值 $game_actors[角色編號].exp 
角色等級 $game_actors[角色編號].level 
角色職業編號 $game_actors[角色編號].class_id 
角色 武器編號 $game_actors[角色編號].weapon_id
角色 盾牌編號 $game_actors[角色編號].armor1 
角色 頭部防具編號 $game_actors[角色編號].armor2 
角色 身體防具編號 $game_actors[角色編號].armor3
角色 裝飾品編號 $game_actors[角色編號].armor4 
角色 力量$game_actors[角色編號].str 
角色 靈巧 $game_actors[角色編號].dex 
角色 智力 $game_actors[角色編號].int 
角色 攻擊力 $game_actors[角色編號].atk
角色 物理防禦 $game_actors[角色編號].pdef 
角色 魔法防禦 $game_actors[角色編號].mdef 
角色 迴避修正 $game_actors[角色編號].eva

敵人 HP   $game_troop.enemies[敵人編號].hp
敵人 SP   $game_troop.enemies[敵人編號].sp
敵人 最大 HP $game_troop.enemies[敵人編號].maxhp
敵人 最大 SP $game_troop.enemies[敵人編號].maxsp
敵人 經驗值 $game_troop.enemies[敵人編號].exp
敵人等級 $game_troop.enemies[敵人編號].level
敵人職業編號 $game_troop.enemies[敵人編號].class_id
敵人 武器編號 $game_troop.enemies[敵人編號].weapon_id
敵人 盾牌編號 $game_troop.enemies[敵人編號].armor1
敵人 頭部防具編號 $game_troop.enemies[敵人編號].armor2
敵人 身體防具編號 $game_troop.enemies[敵人編號].armor3
敵人 裝飾品編號 $game_troop.enemies[敵人編號].armor4
敵人 力量$game_troop.enemies[敵人編號].str
敵人 靈巧 $game_troop.enemies[敵人編號].dex
敵人 智力 $game_troop.enemies[敵人編號].int
敵人 攻擊力 $game_troop.enemies[敵人編號].atk
敵人 物理防禦 $game_troop.enemies[敵人編號].pdef
敵人 魔法防禦 $game_troop.enemies[敵人編號].mdef
敵人 迴避修正 $game_troop.enemies[敵人編號].eva



使用例：
( 1 ) 角色 1   回復 90 HP   =>    $game_actors[1].hp += 90
( 2 ) 角色 1   減少 50 SP   =>    $game_actors[1].sp -= 50
( 3 ) 角色 2   剩餘 HP 設定為 20  =>    $game_actors[2].sp = 20
( 4 ) 敵人 1   HP 全恢復    $game_troop.enemies[1].hp =  $game_troop.enemies[1].maxhp




 





(1) 完全恢復
$game_actors[角色編號].recover_all
(2) 增減特技
A. 增加特技
$game_actors[角色編號].learn_skill(特技編號)
B. 減少特技
$game_actors[角色編號].forget_skill(特技編號)
(3) 變更裝備
裝備類型：0武器，1盾，2頭部防具，3身體防具，4裝飾品
A. 裝備上去
$game_actors[角色編號].equip(裝備類型, 要替換的裝備的編號)
B. 解除裝備
$game_actors[角色編號].equip(裝備類型,0)
(4) 改變角色圖片
$game_actors[角色編號].set_graphic("行走圖圖片", 行走圖色調, "戰鬥圖圖片", 戰鬥圖色調)
$game_player.refresh
※行走圖圖片是指定在「Character」資料底下的圖片，戰鬥圖圖片是指定在「Battler」資料底下的圖片
(5) 戰鬥中斷
$game_temp.battle_abort = true
(6) 呼叫選單畫面
$game_temp.menu_calling = true
(7) 呼叫存檔畫面
$game_temp.save_calling = true
(8) 遊戲結束
$game_temp.gameover = true
(9) 返回標題畫面
$game_temp.to_title = true


=end