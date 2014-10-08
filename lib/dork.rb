module Dork
  require 'ostruct'

  class Node
    attr_accessor :parent, :payload, :children

    def initialize(parent, name)
      if block_given?
        yield(self)
      end
      @parent = parent
      @parent.children << self unless @parent.nil
      @name = name
      @children = []
    end

    def is_inside(parent)
      @parent = parent
    end

    def find(name)
      return self if self.name == name

      children.each do |c|
        result = c.find(name)
        return result unless result.nil?
      end

    end

  end

  class World < Node
  end

  class Room < Node
  end

  class Item < Node
  end

  class Player < Node
    def take(item)
      item.parent = self
    end

  end

end
