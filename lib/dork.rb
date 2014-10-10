module Dork
  require 'ostruct'

  class Node
    attr_accessor :name, :parent, :payload, :children

    def initialize(name, payload=nil)
      @name = name
      @payload = payload 
      @children = []

      if block_given?
        add(yield)
      end
    end

    def add(*children)
      children.flatten.each do |child|
        @children << child
        child.parent = self
      end
    end

    def find(name)
      return self if self.name == name
     
      children.each do |c|
        if c.name == name
          return c
        else
          c.find(name)
        end
      end

    end

    def descendants
      descendants = []
    end

  end

  class World < Node
  end

  class Room < Node
  end

  class Item < Node
  end

  class Player < Node
  end

end
