#==============================================================================
# *** QuestData
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This module contains all the configuration data for the quest journal
#==============================================================================
module QuestData
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Setup Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def self.setup_quest(quest_id)
    q = { objectives: [] }
    case quest_id
    #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    #  BEGIN Editable Region B
    #||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    #    Quest Setup
    #
    #  This is where you set up the data for every quest in the game. While
    # it may seem complicated, I urge you to pay attention and, once you get
    # the hang of it, I am sure it will quickly become second nature. 
    #
    #  Every single quest should be set up in the following format, but note
    # that if you are not setting anything for a particular aspect, you can 
    # delete that line. Anyway, this is what each quest should look like, with
    # the values on the left being the default values if you don't set them:
    #
    #  when quest_id
    #   q[:name]              = "??????"
    #   q[:icon_index]        = 0
    #   q[:level]             = 0
    #   q[:description]       = ""
    #   q[:banner]            = ""
    #   q[:banner_hue]        = 0
    #   q[:objectives][0]     = ""
    #   q[:objectives][1]     = ""
    #   q[:objectives][2]     = ""
    #   q[:objectives][n]     = ""
    #   q[:prime_objectives]  = [0, 1, 2, n]
    #   q[:custom_categories] = []
    #   q[:client]            = ""
    #   q[:location]          = ""
    #   q[:rewards]           = []
    #   q[:common_event_id]   = 0
    #   q[:layout]            = false
    #
    #  For each line, with the exception of objectives, it is only the value on 
    # the right of the equals sign that you will need to change. Now I will 
    # explain each line:
    #
    # when quest_id
    #    quest_id - is an integer of your choosing, and this is how you 
    #        reference a quest in order to advance and do anything else. It 
    #        must be unique for every quest; if you use 1 for the first quest, 
    #        you cannot use 1 for any other quest.
    #
    #   q[:name]              = ""
    #     "" - This line sets the name of the quest which shows in the Quest 
    #        List.
    #   
    #   q[:icon_index]        = 0
    #     0  - This line sets the icon to be used for this quest. It will show
    #        to the left of the quest's name in the Quest List.
    #
    #   q[:level]             = 0
    #     0  - This line sets the level of the quest. If 0, no level will be
    #        shown. See the level options at lines 441-458 for more detail.
    #   
    #   q[:description]       = ""
    #     "" - This line sets the description of the quest. You can use message 
    #        codes in this string, but if you are using "" then you need to use
    #        \\ to identify codes and not just \. Ie. It's \\v[x], not \v[x]
    #
    #   q[:objectives][0]     = ""
    #   q[:objectives][1]     = ""
    #   q[:objectives][2]     = ""
    #   q[:objectives][n]     = ""
    #  Objectives are slightly different. Notice that after q[:objectives] on
    # each line there is an integer enclosed in square brackets:
    #    [n] - This is the ID of the objective, and n MUST be an integer. No 
    #       quest can have more than one objective with the same ID. This is 
    #       how you identify which objective you want to reveal, complete or 
    #       fail. That said, you can make as many objectives as you want, as 
    #       long as you give them all distinct IDs. The IDs should be in 
    #       sequence as well, so there shouldn't be a q[:objectives][5] if 
    #       there is no q[:objectives][4].
    #     "" - This is the text of the objective. You can use message codes in 
    #        this string, but if you are using "" then you will need to use 
    #        \\ to identify codes and not just \. Ie: It's \\v[x], not \v[x]
    #
    #   q[:prime_objectives]  = [0, 1, 2, n]
    #     [0, 1, 2, n] - This array determines what objectives need to be 
    #        completed in order for the quest to be complete. In other words, 
    #        all of the objectives with the IDs in this array need to be 
    #        complete for the quest to be complete. If any one of them is 
    #        failed, the quest will be failed. If you remove this line 
    #        altogether, then all objectives are prime. If you set this to [],
    #        then the quest will never be automatically completed or failed and
    #        you need to use the manual options described at lines 208-219.
    #
    #   q[:custom_categories] = []
    #     [] - This allows you to set an array of custom categories for this
    #        quest, whiich means this quest will show up in each of those 
    #        categories if you add it to the CATEGORIES array at line 370.
    #        Note that each category you make must be identified by a unique 
    #        :symbol, and you must set up all the category details for that 
    #        :symbol. 
    #
    #   q[:banner]            = ""
    #     "" - This line sets the banner to be used for a quest. It must be the
    #        filename of an image in the Pictures folder of Graphics.
    #
    #   q[:banner_hue]        = 0
    #     0 - The hue of the banner graphic, if used
    #
    #   q[:client]            = ""
    #     "" - This line sets the client name for this quest. (basic data)
    #
    #   q[:location]          = ""
    #     "" - This line sets the location of the quest. (basic data)
    #
    #   q[:rewards]           = []
    #    [] - In this array, you can identify particular rewards that will 
    #       show up. Each reward should be in its own array and can be any of
    #       the following:
    #          [:item, ID, n],
    #          [:weapon, ID, n],
    #          [:armor, ID, n],
    #          [:gold, n],
    #          [:exp, n],
    #       where ID is the ID of the item, weapon or armour you want
    #       distributed and n is the amount of the item, weapon, armor, gold, 
    #       or experience you want distributed. Additionally, you can also set
    #       some text to show up in the rewards format but which wouldn't be
    #       automatically distributed. You would need to specify that type of
    #       reward text in the following format:
    #          [:string, icon_index, "string", "vocab"],
    #       where icon_index is the icon to be shown, "string" is what you 
    #       would show up as the amount, and "vocab" is what would show up as a
    #       label between the icon and the amount.
    #      
    #
    #   q[:common_event_id]   = 0
    #     0  - This allows you to call the identified common event immediately
    #        and automatically once the quest is completed. It is generally 
    #        not recommended, as for most quests you should be controlling it
    #        enough not to need this feature.
    #
    #   q[:layout]            = false
    #     false - The default value for this is false, and when it is false the
    #        layout for the quest will be inherited from the default you set at
    #        302. However, you can also give the quest its own layout - the 
    #        format would be the same as you set for the default at line 307.
    #  
    # Template:
    #
    #  When making a new quest, I recommend that you copy and paste the
    # following template, removing whichever lines you don't want to alter. 
    # Naturally, you need to remove the #~. You can do so by highlighting
    # the entire thing and pressing CTRL+Q:
#~     when 2 # <= REMINDER: The Quest ID MUST be unique
#~       q[:name]              = "??????"
#~       q[:icon_index]        = 0
#~       q[:level]             = 0
#~       q[:description]       = ""
#~       # REMINDER: You can make as many objectives as you like, but each must 
#~       # have a unique ID.
#~       q[:objectives][0]     = "" 
#~       q[:objectives][1]     = ""
#~       q[:objectives][2]     = ""
#~       q[:prime_objectives]  = [0, 1, 2]
#~       q[:custom_categories] = []
#~       q[:banner]            = ""
#~       q[:banner_hue]        = 0
#~       q[:client]            = ""
#~       q[:location]          = ""
#~       q[:rewards]           = []
#~       q[:common_event_id]   = 0
    when 1 # Quest 1 - SAMPLE QUEST
      q[:name]              = "Sieged Deadend"
      q[:level]             = 5
      q[:icon_index]        = 7
      q[:description]       = "Crystal Empire is fell to the King Sombra, now must report to the Princess in Canterlot."
      q[:objectives][0]     = "(Main)Escape from Crystal Empire"
      q[:objectives][1]     = "(Selective)Save Crystal Ponies"
      q[:objectives][2]     = "(Selective)Save the librarian"
      q[:objectives][3]     = "Find the mysterious device in the library"
      q[:objectives][4]     = "Gather the infromation in the library, find way to active the device and leave here"
      q[:prime_objectives]  = [1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Mainline Mission"
      q[:location]          = "Crystal Empire"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        #[:item, 1, 3],
        [:gold, 100],
      ]
      q[:layout]            = false
    when 2
      q[:name]              = "Tutorial"
      q[:level]             = 1
      q[:icon_index]        = 230
      q[:description]       = "Learn the game mechanics and how to play."
      q[:objectives][0]     = "Enable the tactic mode"
      q[:objectives][1]     = "Enable the tactic mode, command your teammate move to the flag"
      q[:objectives][2]     = "Enable the tactic mode, command yout teammate to attack the enemy"
      
      q[:prime_objectives]  = [1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "GM"
      q[:location]          = "Celestia Plane"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 1, 3],
      ]
      q[:layout]            = false
    #||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    #  END Editable Region B
    #//////////////////////////////////////////////////////////////////////
    end
    q
  end
end
