require "spec_helper"
require "dork"

module Dork

  describe World do
    it "can be an empty world" do
      World.new(nil, :world) 
    end
  end

  describe Room do
    it "can be a room called 'kitchen' in the world" do
      World.new(nil, :world) do |wrld|
        room = Room.new(wrld, :kitchen)
        expect(room.parent).to eq(wrld)
      end
    end 
  end

  describe Item do
    it "can be an item called 'spoon' in kitchen " do
      World.new(nil, :world) do |wrld|
        Room.new(wrld, :kitchen) do |kit|
          spoon = Item.new(kit, :spoon)
          expect(spoon.parent).to eq(kit)
        end
      end 
    end
  end

  describe Player do
    it "can be a player called 'cody' in kitchen " do
      World.new(nil, :world) do |wrld|
        Room.new(wrld, :kitchen) do |kit|
          player = Player.new(kit, :cody)

          expect(player.parent).to eq(kit)
        end
      end 
    end

    it "can move an item from kitchen to player" do
      World.new(nil, :world) do |wrld|
        Room.new(wrld, :kitchen) do |kit|
          player = Player.new(kit, :cody)
          spoon = Item.new(kit, :spoon)
          expect(spoon.parent).to eq(kit)

          player.take(spoon)

          expect(spoon.parent).to eq(player)
        end
      end 
    end

    it "can move a player from one room to another" do
      world = World.new(nil, :world) do |wrld|
        Room.new(wrld, :bathroom) do |bth|
          Player.new(bth, :cody)
        end

        Room.new(wrld, :kitchen) do |kit|
        end
      end 

      player = world.find(:cody)
      player.move_to(:kitchen)

    end
  end


end
