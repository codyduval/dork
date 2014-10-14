module Dork

  class Node
    attr_accessor :name, :parent, :children, :visible

    def initialize(name, description = "")
      @name = name
      @visible = true
      @description = description
      @children = []

      # So a node add a child via a block
      if block_given?
        add(yield)
      end
    end

    # Appends a child (or children) to the current node.
    # Returns itself so you can chain onto it.
    def add(*children)
      children.flatten.each do |child|
        @children << child
        child.parent = self
      end
      self
    end

    # Returns an array of all children, and their children
    def descendants(list = [])
      unless children.empty?
        children.each do |child|
          list << child
          child.descendants(list)
        end
      end
      list
    end

    # Searches through tree for a node with supplied name.  Obviously won't work if duplicate named nodes exist.
    def find(name)
      if self.name == name
        return self
      else
        children.each do |child|
          result = child.find(name)
          return result unless result.nil?
        end
      end
      nil
    end

    # Climb up tree and return the root of the current node.
    def root
      root = self
      root = root.parent while root.parent != nil
      root
    end

    def player
      root.children.select{|child| child.is_a?(Player)}.last
    end

    def has(name)
      thing = root.find(name)
      children.select{|child| child == thing}.any?
    end

    # Finds and moves named node (and its children) onto current node.
    def get(name)
      root = self.root
      if node = root.find(name)
        node.parent.children.delete(node)
        add(node)
      else
        nil
      end
    end

  end

  class World < Node
  end

  class Room < Node
    attr_accessor :exit_north, :exit_south, :exit_east, :exit_west, :locked, :description

    def initialize(name, description="")
      super
      @exit_north = @exit_south = @exit_east = @exit_west = false
    end

    def visible
      children.select{|c| c.is_a?(Player)}.any?
    end

    def scripts
      children.select{|c| c.is_a?(Script)}
    end

    def has_script?(phrase)
      if script = scripts.select{|script| script.script_keys.include?(phrase)}.last
        script
      else
        false
      end
    end
  end

  class Item < Node
    attr_accessor :can_take, :can_open, :open, :description

    def initialize(name, description="")
      super
      @open = @can_take = @can_open = true
    end

    def visible
      if parent.is_a?(Item) && !parent.open
        false
      else
        true
      end
    end
  end
  
  class Script < Node
    attr_accessor :script_keys, :failure_message, :success_message, :conditions, :actions

    def initialize(name, description="")
      super
      @visible = false
    end
    
    def conditions_met? 
      @conditions && @conditions.each do |cond|
        if eval(cond) != true
          return false
        end
      end
      true
    end

    def is_successful
      @actions && @actions.each do |action|
        eval(action)
      end
      @sucess_message
    end

    def failure
    end
   
  end

  class Player < Node
    alias_method :inventory, :children

    VERBS = %w{pickup go look}
    DIRS = %w{north east south west}

    def initialize(name, description="")
      super
      @visible = false
    end

    def pickup(item_name)
      item = root.find(item_name)
      if (item == nil || item.parent != self.parent)
        "I don't see that here."
      elsif item.can_take != true
        "You can't pick that up right now."
      else
        get(item.name)
      end
    end

    def go(direction)
      current_room = parent
      dir_to_exit = "exit_#{direction}"
      if DIRS.include?(direction) &&
         current_room.send(dir_to_exit) != false 
        move_to(current_room.send(dir_to_exit))
      else
        "You can't go that way"
      end
    end
    
    def look_one(name)
      item_to_see = root.find(name)
      if item_to_see && item_to_see.visible
        item_to_see.description
      else
        "I don't see that here."
      end
    end

    def look(name)
      descriptions = ""
      item_to_see = root.find(name)
      descriptions << item_to_see.description
      item_to_see.children.each do |item|
        if item.visible == true
          descriptions << item.description
        end
      end
      descriptions
    end

    def command(phrase)
      if script = parent.has_script?(phrase)
        conditions_met?(script)
      elsif two_word_phrase?(phrase)
        verb, noun = phrase.split(' ')
        noun = noun.to_sym
        if VERBS.include?(verb)
          puts "#{send(verb, noun)}"
        else
          puts "I can't do that."
        end
      else
        if phrase == "look"
          puts "#{look(parent.name)}"
        else
          puts "Command should be two words, like 'go north'"
        end
      end
    end

    def play
      puts "Welcome. Type 'quit' to exit."
      loop do
        print "> "
        action = gets.chomp
        if action == "quit"
          puts "Bye bye."
          break
        else
          command(action)
        end
      end
    end

    private

    def two_word_phrase?(phrase)
      phrase.split(' ').size >= 2
    end

    def conditions_met?(script)
      if script.conditions_met? == true
        script.is_successful
      else
        puts "#{script.failure_message}"
      end
    end

    def move_to(name)
      root = self.root
      room = root.find(name)
      room.get(self.name)
    end
  end



end
