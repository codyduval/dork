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
      self
    end

    def descendants(list = [])
      unless children.empty?
        children.each do |child|
          list << child
          child.descendants(list)
        end
      end
      list
    end

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

    def root
      root = self
      root = root.parent while root.parent != nil
      root
    end

  end

  class World < Node
  end

  class Room < Node
    attr_accessor :exit_north, :exit_south, :exit_east, :exit_west
  end

  class Item < Node
  end

  class Player < Node
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

end
