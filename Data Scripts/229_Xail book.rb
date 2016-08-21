#==============================================================================
#   XaiL System - History Book
#   Author: Nicke
#   Created: 31/12/2012
#   Edited: 04/01/2013
#   Version: 1.0a
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#==============================================================================
# Requires: XS - Core Script.
#==============================================================================
#
# This script adds a new scene to your game, which can be called by the
# following script call:
# SceneManager.call_ext(Scene_HistBook, :symbol)
#
# Example:
# SceneManager.call_ext(Scene_HistBook, :ancient_book)
#
# Basicially you call the scene with the book you want the player to see.
# In the above example ancient_book is used. Those books can be edited below
# in the settings module.
#
# Each book can have unlimited pages.
# Font and skin settings for the window can be changed.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-HISTORY-BOOK"] = true

module XAIL
  module HIST_BOOK
    #--------------------------------------------------------------------------#
    # * Settings
    #--------------------------------------------------------------------------#
    # FONT:
    # FONT = [name, size, color, bold, shadow]
    FONT = [["Calibri", "Verdana"], 18, Color.new(255,255,255), true, true]
    
    # Setup the books.
    # :title => [page1, page2, page3...]
    # In the array for pages you can use the following to output a string:
    # %{Some text}, "Some text" etc.
    # The title will be converted, capitalized and any underlines will 
    # be removed.
    #--------------------------------------------------------------------------#
    BOOKS = {
    
    
    0 => [%{Please select a valid book to read if you want OWO }],
    #Welcome to Equestria
    301 => [%{
    Equestria is the main setting of the My Little Pony Friendship is Magic franchise. 
    Equestria is inhabited by magical ponies and other talking creatures, such as griffons and dragons. 
    Other animals and creatures also live in Equestria. Equestria is called a kingdom on the first episode of 
    the show and in other media, though it does contain other "kingdoms" within it such as the Crystal Empire
    or Crystal Kingdom; the show and other media take place in many locations and their exact affiliation with
    Equestria is not explored. Equestria is co-ruled by Princess Celestia and Princess Luna, who reside in a palace
    in the city of Canterlot. The name "Equestria" is derived from the word "equestrian" (which means of or related 
    to horseback riding), which stems from equus, the Latin word for "horse.".
                                                                                                                                                                                                                                                                                                                                                                      
    },
    #Blank line: 63
    %{
    The founding of Equestria:                                                                                                                                                                                                                                                                                                                           
    The story of the founding of Equestria is relayed in software, and part of this explanation is covered in 
    Hearth's Warming Eve. The episode's most prominent feature is a play about the founding of Equestria, 
    narrated by Spike. He explains: "each of the three tribes, the Pegasi, the unicorns, and the Earth ponies, 
    cared not for what befell the other tribes, but only for their own welfare. In those troubled times, as now,
    the Pegasi were the stewards of the weather, but they demanded something in return: food that could only be 
    grown by the Earth Ponies. The unicorns demanded the same, in return for magically bringing forth day and 
    night. And so, mistrust between the tribes festered, until one fateful day, it came to a boil. And what prompted 
    the ponies to clash? It was a mysterious blizzard that overtook the land, and toppled the tribes' precarious peace."
    },
    %{
    The blizzard led to famine, at which the three tribal leaders eventually agreed to meet for a summit and decide what to do about the snow, but this only devolved into arguing and blaming each other. The leaders of each tribe then decided to journey to a new land. They all arrived at the same place, and soon began fighting over it, and the blizzard quickly followed. "And so the paradise that the ponies had found was soon lost, buried beneath a thick blanket of snow and hard feelings." Eventually, the leaders' assistants find out windigos are causing the storm by feeding off of hate. The assistants' friendship creates the magical Fire of Friendship which does away with the windigos and the snowstorm.
The three leaders then decide to join forces and found a country shared by all three tribes, and name it Equestria.
    },
    %{Discord's reign of chaos:                                                                                                                                                                                                                                                                                                                         
    The series starts off with a prologue with narration about the princesses ruling Equestria, raising the sun and moon and maintaining harmony. Only in The Return of Harmony Part 1 is the time before their rule mentioned in the series. Princess Celestia tells Twilight Sparkle and her friends that before Princess Luna and herself stood up to Discord, he ruled over Equestria, keeping it in a state of unrest and unhappiness. Celestia goes on to describe that, seeing how miserable life was for Earth ponies, unicorns, and Pegasi alike, she and Luna discovered the Elements of Harmony and rose up against Discord, turning him to stone. Discord's spell is later broken because, as Celestia explains, "Luna and [herself] are no longer connected to the elements", so Twilight and her friends use the Elements of Harmony to encase Discord in stone again.
    },
    %{
    The regal Alicorn sisters                                                                                                                                                                                                                                                               
The princesses are introduced in the prologue of the first episode, depicted in a series of medieval-like drawings with a narration that says "two regal sisters who ruled together and created harmony for all the land", and that "the eldest used her unicorn powers to raise the sun at dawn. The younger brought out the moon to begin the night."
    },
    %{Nightmare Moon :                                                                             
    The narration continues: their subjects, the ponies, played in the day but "shunned" the night and slept through it, which made the younger unicorn grow bitter, eventually refusing to lower the moon to make way for the dawn. Her bitterness transformed her into a "wicked mare of darkness", Nightmare Moon. The elder sister reluctantly harnessed the power of the Elements of Harmony and banished her in the moon, taking responsibility for both sun and moon, maintaining harmony in Equestria. The events of the first and second episodes take place a thousand years after Nightmare Moon's imprisonment, upon which she is freed, but defeated again through the magic of the Elements of Harmony, only this time she is transformed back to her former self and returns to rule Equestria with her sister. In Testing Testing 1, 2, 3, these events are referred to as "The Great Celestia/Luna Rift."
    },
    ],
    
    #Elements of Harmony
    302 => [%{Elements of Harmony are six mystical jewels that harness the power of friendship. Little is known about the enigmatic Elements, but they're extremely powerful and can only be used in unison. },
    %{Their mysterious origins are tied to Equestria's distant past, a time when two Alicorn Sisters, Princess Celestia and Princess Luna, used their magical power to rule the lands. Celestia raised the sun, and Luna raised roused the moon in the evening. As time went on, Luna grew frustrated watching ponies play all day and sleep during the night. She felt her fard work was going unnoticed, and her seething anger and jealous grew until they transformed the otherwise pleasant pony into the vengeful Nightmare Moon. Using her newfound abilities, Nightmare Moon plunged Equestria into drakness. Thankfully, Princess Celestia was able to harness the power of the Elements of Harmony to stop her sister and exile her into the moon for all eternity. Balance has returned to Equestria, but Celestia knew that peace woundn't last forever.},
    %{In the present, young Twilight Sparkle discovered a dark prophecy that heralded the return of Nightmare Moon on the longest day of the thousand year. She desperately contacted Princess Celestia to warn her of of the impending danger, but the princess dismissed Twilight's concern and insisted she focus her attention on the upcoming Summer Sun Celebration. Princess Celestia was convinced that the celebration would yield Twilight a number of new friends, and it certainly did.},
    %{During the event, Twilight Sparkle instantly found five new pony pals: Fluttershy, Pinkie Pie, Rainbowdash , Applejack and Rarity. It seemed, at first, that prophecy was untrue, until suddenly Princess Celestia disappeared and Nightmare Moon once again bought the darkness to Equestria.},
    %{Twilight quickly realized that there was only way to save the day. She and her new friends had to find and retrieve the mystical Elements of Harmony from ancient castle of the royal pony sisters! They traveled through the dangerous Everfree Forest and, after a perilous jounary, finally arrived at the castle. During their quest, the new pony friends confronted a myriad of dangers that brought them closer together in process. Upon finding the Elements, the group was ambushed by Nightmare Moon, who seemingly destroyed the precious stone and doomed Equestria forever.},
    %{ But Twilight Sparkle realized that hope wasn't lost and that her new friends were the key to defeating Nightmare moon. They each embodied the various aspects if the Elements of Harmony,and by working together, they pooled their power and used it against the vengeful Alicorn.},
    %{As Twilight called out the names of her friends, the broken Elements re-formed into sparkling new pendants that gave each other of their new owner a power of friendship! Applejack represented Honesty, Fluttershy embodied the spirit of Kindness, Pinkie Pie brought the group laughter, Rarity exuded Generosity, and Rainbow Dash's strong suit was Loyalty. Twilight Sparkle empbodied the Element of Magic, which only sparked when all the other Elements were presented, Together, the ponies ised their newfound powers to transform Nightmare Moon back into the benevolent form of Princess Luna, once again bringing light to Equestria.},
    %{With the kingdom now safe, Princess Celestia revealed that she knew Twilight Sparkle would be able to save the day by harnessung the power of Elements, The princess then gave Twilight a special mission to chronicle the magic of friendship and report on the valuable lessons she learned. Over time, the Elements of Harmony have been used sparingly, in times of of dire necessity, and never in a harmful or hurtful way. When trouble arises, the duty falls to those six brave ponies to bring peace and order to Equestria once again.},
    ],
    
    #Star Doom
    303 => [
      %{Anti-Magi Sword, Star Doom.  Star Swirl the Bearded , one of the famous unicorn in the history of Equestria , invneted several high-level spells supported Celestia to rule the Equestria. Meanwhile, the class of Unicorn had gradually higher than Pegasus and Earth-Pony.                                                                                                                                                                                                                                                                            
      The radicals of the two latters got very uncomfortable , worried the cold war in the three-trible era happened again, secretly sneak to Crystal Mountain mined the Mithril, Orichalcon, Hihi'irokane etc. magical metal, forged this deadly weapon. The Legend says, the victims under its blade, they will not be able to cast spells for days.},
      %{Ability : Owner Reflect Magic, ATK:200 , -100 MAT, -200 MP},
    ],
    
    #Crystal Portal Coded Document
    304 =>[
        #%{一二三四五七八九零一二三四五七八九零一二三四五七八九零一二三},
        %{今傳送門之性能仍為之不定，為求安全，故加密之。 \n欲使用者，解下10題選擇題之答案為正確之10位數密碼。\n 其每題答案都不能自相矛盾。},
        %{(1)第一個答案是B的題號是第幾題? (A)2       (B)3        (C)4        (D)5        (E)6        \n(2)恰好有兩個連續問題的答案是一樣的，題號是: \n                                                                               (A)2,3        (B)3,4        (C)4,5        (D)5,6        (E)6,7        \n                                                                                                                        (3)本題的答案和哪一題答案一樣? \n(A)1       (B)2        (C)4        (D)7        (E)6        \n(4)答案是A的問題個數是: \n (A)0       (B)1        (C)2        (D)3        (E)4       \n(5)本題答案和第幾題相同?   (A)10       (B)9        (C)8        (D)7        (E)6        \n(6)答案是A的問題個數和答案為多少的個數一樣?   \n                                                                                                         (A)B       (B)C        (C)D        (D)E        (E)以上皆非 \n   (7)按照字母順序，本問題的答案和下一個問題的答案相差幾個字母?    \n           (A)4        (B)3        (C)2        (D)1        (E)0        \n},
        %{(8)答案是母音字母的問題個數是:    (A)2       (B)3        (C)4        (D)5        (E)6        \n(9)答案是子音字母的個數是: \n           (A)一個質數       (B)一個階乘數        (C)一個平方數        (D)一個梅森質數       (E)5的倍數                                                                      \n(10)這題的答案是:    (A)A       (B)B        (C)C        (D)D        (E)E        \n   \n                                                                                                                                                提示:第一題答案有可能是(B)嗎?},
        
    ],
    
    } # Don't remove this line!
    #--------------------------------------------------------------------------#
    
    # Change page text.
    # PAGE_TEXT = string
    PAGE_TEXT = "Change page with Left/Right buttons."
    
    # Single page text.
    # SINGLE_TEXT = string
    SINGLE_TEXT = ""
    
    # Use default background. (snapshot of the map)
    # BACK = true/false
    BACK = true
    
    # Custom background.
    # CUST_BACK = [filename, hide_window]
    # Optional to use, set filename to "" to disable.
    CUST_BACK = ["", false]
    
    # SKIN:
    # The windowskin to use for the windows.
    # Set to nil to disable.
    # SKIN = string
    SKIN = nil
    
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Error Handler
#==============================================================================#
  unless $imported["XAIL-XS-CORE"]
    # // Error handler when XS - Core is not installed.
    msg = "The script %s requires the latest version of XS - Core in order to function properly."
    name = "XS - History Book"
    msgbox(sprintf(msg, name))
    exit
  end
#==============================================================================#
# ** Window_HistoryBook
#==============================================================================#
class Window_HistoryBook < Window_Command
  
  def initialize(x, y)
    # // Method to initialize the window.
    super(x, y)
    @page = 1
  end
  
  def window_width
    # // Method to return the width.
    return Graphics.width
  end
  
  def window_height
    # // Method to return the height.
    return Graphics.height
  end
  
  def set_book(book)
    # // Method to set book.
    if book != @book
      @book = book
      refresh
    end
  end
  
  def change_page(page)
    # // Method to change page.
    if page != @page
      @page = page
      refresh
    end
  end
  
  def refresh
    # // Method to refresh the window.
    super
    contents.clear
    unless @book.nil?
      draw_book 
      draw_details
    end
  end
  
  def draw_book
    book_title = ["History of Equestria","Elements of Harmony","Star Doom","水晶傳送門加密文件",""]
    # // Method to draw the tp text to the window.
    title = @book.to_s.slice_char("_").cap_words
    text = XAIL::HIST_BOOK::BOOKS[@book][@page - 1]
    # // Title.
    if title[0].to_s >= '3' then
      title = book_title[title.to_i - 301]
    elsif title[0] == '0' then
      title = " I just don't know what went wrong O_O"
    end
    draw_font_text(title, 0, 0, contents_width, 1, XAIL::HIST_BOOK::FONT[0], 30, XAIL::HIST_BOOK::FONT[2])
    # // Line.
    draw_line_ex(0,44, Color.new(255,255,255), Color.new(0,0,0))
    # // Book text.
    draw_font_text_ex(text, 0, 72, XAIL::HIST_BOOK::FONT[0], XAIL::HIST_BOOK::FONT[1], XAIL::HIST_BOOK::FONT[2])
  end
  
  def draw_details
    # // Method to draw details.
    current_page = @page.to_s
    max_page = XAIL::HIST_BOOK::BOOKS[@book].size.to_s
    page = "Page: " + current_page + " / " + max_page
    # // Line.
    draw_line_ex(0, contents_height - 36, Color.new(255,255,255), Color.new(0,0,0))
    if XAIL::HIST_BOOK::BOOKS[@book].size > 1 
      # // Change page text.
      page_text = XAIL::HIST_BOOK::PAGE_TEXT
      draw_font_text(page_text, 0, contents_height - calc_line_height(page_text), contents_width, 0, XAIL::HIST_BOOK::FONT[0], 20, XAIL::HIST_BOOK::FONT[2])
      # // Current page and max page.
      draw_font_text(page, 0, contents_height - calc_line_height(page), contents_width, 2, XAIL::HIST_BOOK::FONT[0], 20, XAIL::HIST_BOOK::FONT[2])
    else
      # // Single page text.
      single_text = XAIL::HIST_BOOK::SINGLE_TEXT
      draw_font_text(single_text, 0, contents_height - calc_line_height(single_text), contents_width, 0, XAIL::HIST_BOOK::FONT[0], 20, XAIL::HIST_BOOK::FONT[2])
    end
  end
  
end
#==============================================================================#
# ** Scene_HistBook
#==============================================================================#
class Scene_HistBook < Scene_Base
  
  def initialize(book = nil)
    # // Method to initialize the scene.
    super
    @book = book
  end
  
  def start
    # // Method to start the scene.
    super
    @page = 1
    create_history_window
    create_background if XAIL::HIST_BOOK::BACK
    create_custom_background unless XAIL::HIST_BOOK::CUST_BACK[0] == ""
  end
  
  def create_background
    # // Method to create a background.
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_custom_background
    # // Method to create a custom background.
    begin
      @custom_background = Sprite.new
      @custom_background.bitmap = Cache.picture(XAIL::HIST_BOOK::CUST_BACK[0])
    rescue
      msgbox("Error! Unable to locate the custom background: " + XAIL::HIST_BOOK::CUST_BACK[0])
      exit
    end  
  end
  
  def valid_book?
    # // Method to check if book is valid. (included in book list)
    # // Return (skip it) if included else show error.
    return if XAIL::HIST_BOOK::BOOKS.include?(@book)
    #msgbox("Error! The book " + @book.to_s + " is not added in the list.")
    @book = 0
  end
  
  def create_history_window
    # // Method to create command list window.
    # // Check first if book is a valid one, i.e it is added in the book list.
    valid_book?
    @history_window = Window_HistoryBook.new(0, 0)
    @history_window.opacity = 0 if XAIL::HIST_BOOK::CUST_BACK[1]
    @history_window.windowskin = Cache.system(XAIL::HIST_BOOK::SKIN) unless XAIL::HIST_BOOK::SKIN.nil?
    # // Add page left/right methods if a book have more then one page.
    if XAIL::HIST_BOOK::BOOKS[@book].size > 1
      @history_window.set_handler(:pageright, method(:next_page))
      @history_window.set_handler(:pageleft,  method(:prev_page))
    end
    @history_window.set_handler(:cancel, method(:return_scene))
    @history_window.set_book(@book)
    @history_window.unselect
  end
  
  def next_page
    Audio.se_stop
    # // Method to select next page.
    @page += 1 unless @page == XAIL::HIST_BOOK::BOOKS[@book].size
    Audio.se_play("Audio/SE/Book2",80, 100)
    @history_window.activate
    @history_window.change_page(@page)
  end
  
  def prev_page
    Audio.se_stop
    # // Method to select previous page.
    @page -= 1 unless @page == 1
    Audio.se_play("Audio/SE/Book2",80, 100)
    @history_window.activate
    @history_window.change_page(@page)
  end

end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#