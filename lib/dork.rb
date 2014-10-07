module Dork
  require 'ostruct'

  class Node < OpenStruct

    def initialize(type, parent, &block)
      super()
      self.parent = parent
      self.type = type
      self.children = []

      instance_eval(&block) unless block.nil?
    end

    def self.world(&block)
      Node.new(:world, nil, &block)
    end

    def room(type, &block)
      Node.new(type, self, &block)
    end

  end

end
