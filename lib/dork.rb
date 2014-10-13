module Dork

  class Node
    attr_accessor :name, :parent, :payload, :children

    def initialize(name)
      @name = name
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

    def initialize(name)
      super
      @exit_north = @exit_south = @exit_east = @exit_west = false
    end
  end

  class Item < Node
    attr_accessor :can_take, :can_open, :open, :description

    def initialize(name)
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

  class Player < Node
    alias_method :inventory, :children

    VERBS = %w{pickup go}
    DIRS = %w{north east south west}

    def pickup(item_name)
      item = root.find(item_name)
      if (item == nil || item.parent != self.parent)
        puts "I don't see that here."
      elsif item.can_take != true
        puts "You can't pick that up right now."
      else
        get(item.name)
      end
    end

    def go(direction)
      current_room = parent
      dir_to_exit = "exit_#{direction}"
      if DIRS.include?(direction) &&
         current_room.send(dir_to_exit) == true
        move_to(current_room.send(dir_to_exit))
      else
        puts "You can't go that way"
      end
    end

    def command(phrase)
      if phrase.split(' ').size == 2
        verb, noun = phrase.split(' ')
        noun = noun.to_sym
        if VERBS.include?(verb)
          send(verb, noun)
        else
          puts "I can't do that."
        end
      else
        puts "Command should be two words, like 'go north'"
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

    def move_to(name)
      root = self.root
      room = root.find(name)
      room.get(self.name)
    end
  end



end
