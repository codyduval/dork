require "spec_helper"
require "dork"

module Dork

  describe Node do
    it "can be an empty world" do
      world = Node.world
      expect(world).to be_instance_of(Node)
    end

    it "can be a room called 'kitchen' in the world" do
      world = Node.world do 
        self.room(:kitchen)
      end

      expect(world).to eq("99")
    end 

    it "can be an item" do
    end

    it "can be a bowl inside a kitchen" do
    end

    it "can be a player in a room" do
    end

  end

end
