=begin

 Self Data: Event Self Data 2.1 (Self Variables & Self Metadata)
 by PK8
 Created: 9/16/2009
 Modified: 5/12/2012
 ──────────────────────────────────────────────────────────────────────────────
 ■ Table of Contents
   ○ Author's Notes                                - Line 17-32
   ○ Introduction & Description                    - Line 34-39
   ○ Features                                      - Line 41-44
   ○ Changelog                                     - Line 46-52
   ○ Methods Aliased                               - Line 54-57
   ○ Thanks                                        - Line 59-79
   ○ How to Use                                    - Line 81-173
 ──────────────────────────────────────────────────────────────────────────────
 ■ Author's Notes
   Before I was able to get anywhere NEAR Self Variables, I needed to find a
   list of arguments in the script calls that worked. At first I tried *args
   and figured I could just turn that into (map_id, event_id, id, value, oper)
   but then trim that down when the size of the argument got smaller. Nope!
   That ended up confusing the hell out of me and I couldn't quite figure out
   what to do when args' size gets to 3. Should I have done 
   (event_id, id, value), (id, value, oper), or (map_id, event_id, id)? I was
   getting frustrated over it so then I thought "Okay, back to the drawing
   board. I should just revise the arguments in my Self Switch script before
   I get anywhere near this," and man did that take me HOURS to do.
   
   For my Self Switches script, as well as this (Self Variables/Metadata)
   script, I wanted to start expanding on the script calls so I checked out an
   old thread of mine and read up on Kain Nobel's suggestions from a few years
   ago and I liked them.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Introduction & Description
   This script is similar to that of RPG Maker's built in self-switches
   feature, but instead of attaching switches to events, you get to attach
   self variables and metadata onto them. This is useful should you ever want
   to create a mood system or make evented NPCs feel more individual just to
   name a few examples.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Features
   Set initial values for event self variables and metadata.
   Set variables and metadata for events through call script.
   Get variables and metadata for events through call script.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Changelog
   v1  (9/16/2009): Initial release.
   v2  (4/24/2012): Combines Self Variables, Self Metadata (formerly known as
                    Self Parameters), AutoSelfVariables, and AutoSelfParameters
                    into one script. This also features some major improvements
                    that were made to the script calls.
   v2.1(5/12/2012): Bravo2kilo found some typos in this script. (typo: "rxdata")
 ──────────────────────────────────────────────────────────────────────────────
 ■ Methods Aliased
   o create_game_objects of DataManager module
   o make_save_contents of DataManager module
   o extract_save_contents of DataManager module
 ──────────────────────────────────────────────────────────────────────────────
 ■ Thanks
   Lowell: A few years prior to the making of this script, he offhandedly
           mentioned something about giving personal variables to... I forgot
           what, but it was for a project of his. And then the "scripting bug,"
           as DerVVulfman calls it, bit me.
   FoxDemonSoavi: If it weren't for her being a fan of my self data scripts,
                  I wouldn't have improved this.
   Kain Nobel: A few years ago, he provided some suggestions on my self
               variables script and suggested some nice ideas I should've added
               onto the script calls.
   Karltheking4: For discovering a bug (which I didn't know about) that my
                 original script had where it would throw an error when
                 using the self_variables script call on a parallel processed
                 event within the first few frames of starting a new game.
   Night_Runner: For coming up with a fix to the aforementioned bug in the
                 original by swapping two lines of code.
   IceDragon/Jet: They helped me out when it came down to figuring out how to
                  call up how many maps were made in the project.
   Yami: Helped out when it came to aliasing methods in a module and having to
         deal with how VX Ace's DataManager handled file saving and loading.
   Nicke: Helped take out some redundancy by a line in the DataManager code.
 ──────────────────────────────────────────────────────────────────────────────
 ■ How to Use
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Script calls                                                           │
 └──────────────────────────────────────────────────────────────────────────┘
      Script calls for setting and getting Event Self Variables.
     
  Set: self_variable([map_id, event_id, id], value, oper)
  Get: self_variable([map_id, event_id, id])
    * map_id  : Set the map ID of the event you're applying the self variable to
    * event_id: The event's ID.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    * oper    : 0: Equal / 1: Add / 2: Sub / 3: Multiply / 4: Divide / 5: Modulo

  Set: self_variable([event_id, id], value, oper)
  Get: self_variable([event_id, id])
    * This applies the self variable to an Event ID within the current map.
    * event_id: The event's ID within the current map.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    * oper    : 0: Equal / 1: Add / 2: Sub / 3: Multiply / 4: Divide / 5: Modulo

  Set: self_variable(id, value)
  Get: self_variable(id)
    * This applies the self variable to This Event ID.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    
      Script calls for setting and getting Event Self Metadata.
     
  Set: self_metadata([map_id, event_id, id], value)
  Get: self_metadata([map_id, event_id, id])
    * map_id  : Set the map ID of the event you're applying the self metadata to
    * event_id: The event's ID.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.

  Set: self_metadata([event_id, id], value)
  Get: self_metadata([event_id, id])
    * This applies the self metadata to an Event ID within the current map.
    * event_id: The event's ID within the current map.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.

  Set: self_metadata(id, value)
  Get: self_metadata(id)
    * This applies the self metadata to This Event ID.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.
    
  map_id/event_id: Integers, ranges, and arrays are allowed. Nil = Everything.
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Using Get script calls in conditional branches                         │
 └──────────────────────────────────────────────────────────────────────────┘
      Script calls to get an Event's Self Variable.
      
 To do this, go to the conditional branch event command, click on the fourth
 tab, select Script and type either of these in the input form:
    self_variable([map_id, event_id, id]) == value   <- Equal to
    self_variable([map_id, event_id, id]) >= value   <- Greater Than or Equal
    self_variable([map_id, event_id, id]) <= value   <- Less Than or Equal
    self_variable([map_id, event_id, id]) > value    <- Greater Than
    self_variable([map_id, event_id, id]) < value    <- Less Than
    self_variable([map_id, event_id, id]) != value   <- Not Equal To

    self_variable([event_id, id]) == value           <- Equal to
    self_variable([event_id, id]) >= value           <- Greater Than or Equal
    self_variable([event_id, id]) <= value           <- Less Than or Equal
    self_variable([event_id, id]) > value            <- Greater Than
    self_variable([event_id, id]) < value            <- Less Than
    self_variable([event_id, id]) != value           <- Not Equal To
    
    self_variable(id) == value                       <- Equal to.
    self_variable(id) >= value                       <- Greater Than or Equal.
    self_variable(id) <= value                       <- Less Than or Equal
    self_variable(id) > value                        <- Greater Than
    self_variable(id) < value                        <- Less Than
    self_variable(id) != value                       <- Not Equal To
    
      Script calls to get an Event's Self Metadata.
    self_metadata([map_id, event_id, id]) == value   <- Equal to.
    self_metadata([map_id, event_id, id]) != value   <- Not Equal to.

    self_metadata([event_id, id]) == value           <- Equal to.
    self_metadata([event_id, id]) != value           <- Not Equal to.

    self_metadata(id) == value                       <- Equal to.
    self_metadata(id) != value                       <- Not Equal to.
    
      These aren't the only conditionals you can use. There's plenty more, but
      it's up to you and experiment with them. I recommend looking up the
      RPG Maker help file on Strings, Integers, and more.
      
=end

#==============================================================================
# * Configuration
#==============================================================================

module SelfData
  class Event
=begin
    Setting shortcuts. There are many ways to set up your initial Event
    self switches.
    
    Type[[map_id, event_id, id]] = value
      * map_id: Integers/Ranges/Arrays are allowed. Nil = All map IDs
      * event_id: Integers/Ranges/Arrays are allowed. Nil = All event IDs
      * id: Data name (Case sensitive)
=end
    
    #--------------------------------------------------------------------------
    # * Do not modify
    #--------------------------------------------------------------------------
    Variables, Metadata = {}, {}

    #--------------------------------------------------------------------------
    # General settings
    #--------------------------------------------------------------------------
    Sensitive_IDs = true      # Enable/disable case-sensitivity for IDs.
    Sensitive_Values = true   # Enable/disable case-sensitivity for values.
                              # * Keep in mind that turning this setting on
                              #   can't help you with if conditionals.
                              #   If TRUE, upcases ID & Value strings.
                                     
    #--------------------------------------------------------------------------
    # * Set up Initial self variables for events.
    # Variables[[map_id, event_id, id]] = value
    #--------------------------------------------------------------------------
    #Variables[[1, 1, "A"]] = 0
    
    #--------------------------------------------------------------------------
    # * Set up Initial self metadata for events.
    # Metadata[[map_id, event_id, id]] = value
    #--------------------------------------------------------------------------
    #Metadata[[1, 1, "A"]] = ""
  end
end

#==============================================================================
# ** Game_SelfVariables
#------------------------------------------------------------------------------
#  This class handles self variables. It's a wrapper for the built-in class
#  "Hash." Refer to "$game_self_variables" for the instance of this class.
#==============================================================================

class Game_SelfVariables
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
    SelfData::Event::Variables.each { |k, v|
      if SelfData::Event::Sensitive_IDs == false and k[2].is_a?(String)
        k[2] = k[2].upcase
      end
      if k[0].is_a?(Integer)    # If Map ID is an Integer
        if k[1].is_a?(Integer)  # If Event ID is an Integer
          @data[k] = v
        elsif k[1].is_a?(Range) # If Event ID is a range
          for i in k[1]
            @data[[k[0], i, k[2]]] = v
          end
        elsif k[1].is_a?(Array) # If Event ID is an array
          for i in 0..k[1].size - 1
            if k[1][i].is_a?(Integer)
              @data[[k[0], k[1][i], k[2]]] = v
            elsif k[1][i].is_a?(Range)
              for ir in k[1][i]
                @data[[k[0], ir, k[2]]] = v
              end
            end
          end
        elsif k[1] == nil       # If Event ID is nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", k[0])).events.keys
            @data[[k[0], i, k[2]]] = v
          end
        end
      elsif k[0].is_a?(Range)   # If Map ID is a Range
        for ir in k[0]
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[ir, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir2 in k[1]
              @data[[ir, ir2, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[ir, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir2 in k[1][i]
                  @data[[ir, ir2, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil       # If Event ID is nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", ir)).events.keys
              @data[[ir, i, k[2]]] = v
            end
          end
        end
      elsif k[0].is_a?(Array)     # If Map ID is an array
        for i in 0..k[0].size - 1
          if k[0][i].is_a?(Integer) # If Map ID contains an integer
            if k[1].is_a?(Integer)  # If Event ID is an Integer
              @data[[k[0][i], k[1], k[2]]] = v
            elsif k[1].is_a?(Range) # If Event ID is a Range
              for ir in k[1]
                @data[[k[0][i], ir, k[2]]] = v
              end
            elsif k[1].is_a?(Array) # If Event ID is an array
              for i2 in 0..k[1].size - 1
                if k[1][i2].is_a?(Integer)
                  @data[[k[0][i], k[1][i2], k[2]]] = v
                elsif k[1][i2].is_a?(Range)
                  for ir in k[1][i2]
                    @data[[k[0][i], ir, k[2]]] = v
                  end
                end
              end
            elsif k[1] == nil       # If Event ID is nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", k[0][i])
                  ).events.keys
                @data[[k[0][i], i2, k[2]]] = v
              end
            end
          elsif k[0][i].is_a?(Range)  # If Map ID contains a Range
            for ir in k[0][i]
              if k[1].is_a?(Integer)  # If Event ID is an Integer
                @data[[ir, k[1], k[2]]] = v
              elsif k[1].is_a?(Range) # If Event ID is a Range
                for ir2 in k[1]
                  @data[[ir, ir2, k[2]]] = v
                end
              elsif k[1].is_a?(Array) # If Event ID is an array
                for i in 0..k[1].size - 1
                  if k[1][i].is_a?(Integer)
                    @data[[ir, k[1][i], k[2]]] = v
                  elsif k[1][i].is_a?(Range)
                    for ir2 in k[1][i]
                      @data[[ir, ir2, k[2]]] = v
                    end
                  end
                end
              elsif k[1] == nil       # If Event ID is nil
                for i2 in load_data(sprintf("Data/Map%03d.rvdata2", ir)
                    ).events.keys
                  @data[[ir, i2, k[2]]] = v
                end
              end
            end
          end
        end
      elsif k[0] == nil           # If Map ID is nil
        for i in load_data("Data/Mapinfos.rvdata2").keys
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[i, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir in k[1]
              @data[[i, ir, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[i, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir in k[1][i]
                  @data[[i, ir, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil
            for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
              @data[[i, i2, k[2]]] = v
            end
          end
        end
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Get Self Variable
  #     key : key
  #--------------------------------------------------------------------------
  def [](key)
    if @data[key] == nil
      return 0
    else
      return @data[key]
    end
  end
  #--------------------------------------------------------------------------
  # * Set Self Variable
  #     key   : key
  #     value : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  def []=(key, value)
    @data[key] = value
  end
end

#==============================================================================
# ** Game_SelfMetadata
#------------------------------------------------------------------------------
#  This class handles self metadata. It's a wrapper for the built-in class
#  "Hash." Refer to "$game_self_metadata" for the instance of this class.
#==============================================================================

class Game_SelfMetadata
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
    SelfData::Event::Metadata.each { |k, v|
      if SelfData::Event::Sensitive_IDs == false and k[2].is_a?(String)
        k[2] = k[2].upcase
      end
      if SelfData::Event::Sensitive_Values == false and v.is_a?(String)
        v = v.downcase
      end
      if k[0].is_a?(Integer)    # If Map ID is an Integer
        if k[1].is_a?(Integer)  # If Event ID is an Integer
          @data[k] = v
        elsif k[1].is_a?(Range) # If Event ID is a range
          for i in k[1]
            @data[[k[0], i, k[2]]] = v
          end
        elsif k[1].is_a?(Array) # If Event ID is an array
          for i in 0..k[1].size - 1
            if k[1][i].is_a?(Integer)
              @data[[k[0], k[1][i], k[2]]] = v
            elsif k[1][i].is_a?(Range)
              for ir in k[1][i]
                @data[[k[0], ir, k[2]]] = v
              end
            end
          end
        elsif k[1] == nil       # If Event ID is nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", k[0])).events.keys
            @data[[k[0], i, k[2]]] = v
          end
        end
      elsif k[0].is_a?(Range)   # If Map ID is a Range
        for ir in k[0]
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[ir, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir2 in k[1]
              @data[[ir, ir2, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[ir, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir2 in k[1][i]
                  @data[[ir, ir2, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil       # If Event ID is nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", ir)).events.keys
              @data[[ir, i, k[2]]] = v
            end
          end
        end
      elsif k[0].is_a?(Array)     # If Map ID is an array
        for i in 0..k[0].size - 1
          if k[0][i].is_a?(Integer) # If Map ID contains an integer
            if k[1].is_a?(Integer)  # If Event ID is an Integer
              @data[[k[0][i], k[1], k[2]]] = v
            elsif k[1].is_a?(Range) # If Event ID is a Range
              for ir in k[1]
                @data[[k[0][i], ir, k[2]]] = v
              end
            elsif k[1].is_a?(Array) # If Event ID is an array
              for i2 in 0..k[1].size - 1
                if k[1][i2].is_a?(Integer)
                  @data[[k[0][i], k[1][i2], k[2]]] = v
                elsif k[1][i2].is_a?(Range)
                  for ir in k[1][i2]
                    @data[[k[0][i], ir, k[2]]] = v
                  end
                end
              end
            elsif k[1] == nil       # If Event ID is nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", k[0][i])
                  ).events.keys
                @data[[k[0][i], i2, k[2]]] = v
              end
            end
          elsif k[0][i].is_a?(Range)  # If Map ID contains a Range
            for ir in k[0][i]
              if k[1].is_a?(Integer)  # If Event ID is an Integer
                @data[[ir, k[1], k[2]]] = v
              elsif k[1].is_a?(Range) # If Event ID is a Range
                for ir2 in k[1]
                  @data[[ir, ir2, k[2]]] = v
                end
              elsif k[1].is_a?(Array) # If Event ID is an array
                for i in 0..k[1].size - 1
                  if k[1][i].is_a?(Integer)
                    @data[[ir, k[1][i], k[2]]] = v
                  elsif k[1][i].is_a?(Range)
                    for ir2 in k[1][i]
                      @data[[ir, ir2, k[2]]] = v
                    end
                  end
                end
              elsif k[1] == nil       # If Event ID is nil
                for i2 in load_data(sprintf("Data/Map%03d.rvdata2", ir)
                    ).events.keys
                  @data[[ir, i2, k[2]]] = v
                end
              end
            end
          end
        end
      elsif k[0] == nil           # If Map ID is nil
        for i in load_data("Data/Mapinfos.rvdata2").keys
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[i, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir in k[1]
              @data[[i, ir, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[i, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir in k[1][i]
                  @data[[i, ir, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil
            for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
              @data[[i, i2, k[2]]] = v
            end
          end
        end
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Get Self Metadata
  #     key : key
  #--------------------------------------------------------------------------
  def [](key)
    return @data[key] if @data[key] != nil
  end
  #--------------------------------------------------------------------------
  # * Set Self Metadata
  #     key   : key
  #     value : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  def []=(key, value)
    @data[key] = value
  end
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Control Event Self Variable
  #--------------------------------------------------------------------------
  def self_variable(id, value = nil, oper = nil)
    id = id[0] if id.is_a?(Array) and id.size == 1
    if !id.is_a?(Array)
      if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
        id = id.upcase
      end
      if @event_id > 0
        key = [@map_id, @event_id, id]
        if value != nil
          case oper
          when nil, 0, 'equal', 'set', '='                     # Setting
            $game_self_variables[key] = value
          when 1, 'add', '+'                                   # Adding
            $game_self_variables[key] += value
          when 2, 'sub', 'subtract', '-'                       # Subtracting
            $game_self_variables[key] -= value
          when 3, 'mul', 'multiply', 'x', '*'                  # Multiplying
            $game_self_variables[key] *= value
          when 4, 'div', 'divide', '/'                         # Dividing
            $game_self_variables[key] /= value if value != 0
          when 5, 'mod', 'modular', '%'                        # Modulating
            $game_self_variables[key] %= value if value != 0
          end
        else
          return $game_self_variables[key]
        end
      end
    else
      case id.size
      when 3 # Map ID, Event ID, ID
        map_id, event_id, id = id[0], id[1], id[2]
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        # Combine ranges and integers into one array
        #   Map IDs
        if map_id.is_a?(Array)
          array1 = []
          for i in 0..map_id.size - 1
            if map_id[i].is_a?(Integer)
              array1.push(map_id[i])
            elsif map_id[i].is_a?(Range)
              array2 = map_id[i].to_a
              array1.concat(array2)
            end
          end
          map_id = array1
        elsif map_id.is_a?(Range)
          map_id = map_id.to_a
        end
        #   Event IDs
        if event_id.is_a?(Array)
          array1 = []
          for i in 0..event_id.size - 1
            if event_id[i].is_a?(Integer)
              array1.push(event_id[i])
            elsif event_id[i].is_a?(Range)
              array2 = event_id[i].to_a
              array1.concat(array2)
            end
          end
          event_id = array1
        elsif event_id.is_a?(Range)
          event_id = event_id.to_a
        end
        # Start
        if map_id.is_a?(Integer)
          if event_id.is_a?(Integer)
            key = [map_id, event_id, id]
            if value != nil
              case oper
              when nil, 0, 'equal', 'set', '='                   # Setting
                $game_self_variables[key] = value
              when 1, 'add', '+'                                 # Adding
                $game_self_variables[key] += value
              when 2, 'sub', 'subtract', '-'                     # Subtracting
                $game_self_variables[key] -= value
              when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                $game_self_variables[key] *= value
              when 4, 'div', 'divide', '/'                       # Dividing
                $game_self_variables[key] /= value if value != 0
              when 5, 'mod', 'modular', '%'                      # Modulating
                $game_self_variables[key] %= value if value != 0
              end
            else
              return $game_self_variables[key]
            end
          elsif event_id.is_a?(Array)
            array = [] if value == nil
            for i in 0..event_id.size - 1
              key = [map_id, event_id[i], id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            end
            return array if value == nil
          elsif event_id == nil
            array = [] if value == nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)
                ).events.keys
              key = [map_id, i, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            end
            return array if value == nil
          end
        elsif map_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..map_id.size - 1
            if event_id.is_a?(Integer)
              key = [map_id[i], event_id, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id.size - 1
                key = [map_id[i], event_id[i2], id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", map_id[i])
                  ).events.keys
                key = [map_id[i], i2, id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            end
          end
          return array if value == nil
        elsif map_id == nil
          array = [] if value == nil
          for i in load_data("Data/Mapinfos.rvdata2").keys
            if event_id.is_a?(Integer)
              key = [i, event_id, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                 # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                               # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                   # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                     # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                    # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id - 1
                key = [i, event_id[i2], id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
                key = [map_id[i], i2, id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            end
          end
          return array if value == nil
        end
      when 2 # Event ID, Map ID (Current Map)
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        map_id, event_id, id = @map_id, id[0], id[1]
        if event_id.is_a?(Integer)
          key = [map_id, event_id, id]
          if value != nil
            case oper
            when nil, 0, 'equal', 'set', '='                 # Setting
              $game_self_variables[key] = value
            when 1, 'add', '+'                               # Adding
              $game_self_variables[key] += value
            when 2, 'sub', 'subtract', '-'                   # Subtracting
              $game_self_variables[key] -= value
            when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
              $game_self_variables[key] *= value
            when 4, 'div', 'divide', '/'                     # Dividing
              $game_self_variables[key] /= value if value != 0
            when 5, 'mod', 'modular', '%'                    # Modulating
              $game_self_variables[key] %= value if value != 0
            end
          else
            return $game_self_variables[key]
          end
        elsif event_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..event_id.size - 1
            key = [map_id, event_id[i], id]
            if value != nil
              case oper
              when nil, 0, 'equal', 'set', '='                 # Setting
                $game_self_variables[key] = value
              when 1, 'add', '+'                               # Adding
                $game_self_variables[key] += value
              when 2, 'sub', 'subtract', '-'                   # Subtracting
                $game_self_variables[key] -= value
              when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                $game_self_variables[key] *= value
              when 4, 'div', 'divide', '/'                     # Dividing
                $game_self_variables[key] /= value if value != 0
              when 5, 'mod', 'modular', '%'                    # Modulating
                $game_self_variables[key] %= value if value != 0
              end
            else
              array.push($game_self_variables[key])
            end
          end
          return array if value == nil
        elsif event_id == nil
          array = [] if value == nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)).events.keys
            if value != nil
              $game_self_variables[[map_id, i, id]] = value
            else
              array.push($game_self_variables[[map_id, i, id]])
            end
          end
          return array if value == nil
        end
      end
    end
    $game_map.need_refresh = true
    return true
  end
  #--------------------------------------------------------------------------
  # * Control Event Self Metadata
  #--------------------------------------------------------------------------
  def self_metadata(id, value = nil)
    id = id[0] if id.is_a?(Array) and id.size == 1
    if !id.is_a?(Array)
      if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
        id = id.upcase
      end
      if SelfData::Event::Sensitive_Values == false and value.is_a?(String)
        value = value.downcase
      end
      if @event_id > 0
        key = [@map_id, @event_id, id]
        if value != nil
          $game_self_metadata[key] = value
        else
          return $game_self_metadata[key]
        end
      end
    else
      case id.size
      when 3 # Map ID, Event ID, ID
        map_id, event_id, id = id[0], id[1], id[2]
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        if SelfData::Event::Sensitive_Values == false and value.is_a?(String)
          value = value.downcase
        end
        # Combine ranges and integers into one array
        #   Map IDs
        if map_id.is_a?(Array)
          array1 = []
          for i in 0..map_id.size - 1
            if map_id[i].is_a?(Integer)
              array1.push(map_id[i])
            elsif map_id[i].is_a?(Range)
              array2 = map_id[i].to_a
              array1.concat(array2)
            end
          end
          map_id = array1
        elsif map_id.is_a?(Range)
          map_id = map_id.to_a
        end
        #   Event IDs
        if event_id.is_a?(Array)
          array1 = []
          for i in 0..event_id.size - 1
            if event_id[i].is_a?(Integer)
              array1.push(event_id[i])
            elsif event_id[i].is_a?(Range)
              array2 = event_id[i].to_a
              array1.concat(array2)
            end
          end
          event_id = array1
        elsif event_id.is_a?(Range)
          event_id = event_id.to_a
        end
        # Start
        if map_id.is_a?(Integer)
          if event_id.is_a?(Integer)
            $game_self_metadata[[map_id, event_id, id]] = value if value != nil
            return $game_self_metadata[[map_id, event_id, id]] if value == nil
          elsif event_id.is_a?(Array)
            array = [] if value == nil
            for i in 0..event_id.size - 1
              if value != nil
                $game_self_metadata[[map_id, event_id[i], id]] = value
              else
                array.push($game_self_metadata[[map_id, event_id[i], id]])
              end
            end
            return array if value == nil
          elsif event_id == nil
            array = [] if value == nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)
                ).events.keys
              if value != nil
                $game_self_metadata[[map_id, i, id]] = value
              else
                array.push($game_self_metadata[[map_id, i, id]])
              end
            end
            return array if value == nil
          end
        elsif map_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..map_id.size - 1
            if event_id.is_a?(Integer)
              if value != nil
                $game_self_metadata[[map_id[i], event_id, id]] = value
              else
                array.push($game_self_metadata[[map_id[i], event_id, id]])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id.size - 1
                if value != nil
                  $game_self_metadata[[map_id[i], event_id[i2], id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], event_id[i2], 
                    id]])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", map_id[i])
                  ).events.keys
                if value != nil
                  $game_self_metadata[[map_id[i], i2, id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], i2, id]])
                end
              end
            end
          end
          return array if value == nil
        elsif map_id == nil
          array = [] if value == nil
          for i in load_data("Data/Mapinfos.rvdata2").keys
            if event_id.is_a?(Integer)
              if value != nil
                $game_self_metadata[[i, event_id, id]] = value
              else
                array.push($game_self_metadata[[i, event_id, id]])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id - 1
                if value != nil
                  $game_self_metadata[[i, event_id[i2], id]] = value
                else
                  array[i].push($game_self_metadata[[i, event_id[i2], id]])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
                if value != nil
                  $game_self_metadata[[map_id[i], i2, id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], i2, id]])
                end
              end
            end
          end
          return array if value == nil
        end
      when 2 # Event ID, Map ID (Current Map)
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        map_id, event_id, id = @map_id, id[0], id[1]
        if event_id.is_a?(Integer)
          $game_self_metadata[[map_id, event_id, id]] = value if value != nil
          return $game_self_metadata[[map_id, event_id, id]] if value == nil
        elsif event_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..event_id.size - 1
            if value != nil
              $game_self_metadata[[map_id, event_id[i], id]] = value
            else
              array.push($game_self_metadata[[map_id, event_id[i], id]])
            end
          end
          return array if value == nil
        elsif event_id == nil
          array = [] if value == nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)).events.keys
            if value != nil
              $game_self_metadata[[map_id, i, id]] = value
            else
              array.push($game_self_metadata[[map_id, i, id]])
            end
          end
          return array if value == nil
        end
      end
    end
    $game_map.need_refresh = true
    return true
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================

class << DataManager
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  unless self.method_defined?(:pk8_selfdata_create_game_objects)
    alias_method(:pk8_selfdata_create_game_objects, :create_game_objects)
  end
  unless self.method_defined?(:pk8_selfdata_make_save_contents)
    alias_method(:pk8_selfdata_make_save_contents, :make_save_contents)
  end
  unless self.method_defined?(:pk8_selfdata_extract_save_contents)
    alias_method(:pk8_selfdata_extract_save_contents, :extract_save_contents)
  end
  #--------------------------------------------------------------------------
  # * Create Game Objects
  #--------------------------------------------------------------------------
  def create_game_objects
    pk8_selfdata_create_game_objects
    $game_self_variables = Game_SelfVariables.new
    $game_self_metadata = Game_SelfMetadata.new
  end
  #--------------------------------------------------------------------------
  # * Create Save Contents
  #--------------------------------------------------------------------------
  def make_save_contents
    contents = pk8_selfdata_make_save_contents
    contents[:self_variables] = $game_self_variables
    contents[:self_metadata] = $game_self_metadata
    contents
  end
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  def extract_save_contents(contents)
    pk8_selfdata_extract_save_contents(contents)
    $game_self_variables = contents[:self_variables]
    $game_self_metadata = contents[:self_metadata]
  end
end