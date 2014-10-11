require "spec_helper"
require "dork"

module Dork

  describe Node do

    it "can add a child" do
      root = Node.new(:root)
      child = Node.new(:child)
      root.add(child)

      expect(root.children).to include(child)
    end

    it "can add a child via a block" do
      root = Node.new(:root) do
        Node.new(:child)
      end

      expect(root.children.count).to eq(1)

      child = root.children.first
      expect(child.parent).to eq(root)
      expect(root.children).to include(child)
    end

    it "can add a 2 siblings via a block" do
      root = Node.new(:root) do
        [Node.new(:first_child), Node.new(:second_child)]
      end

      expect(root.children.count).to eq(2)

      child = root.children.first
      child2 = root.children.last
      expect(child.parent).to eq(root)
      expect(child.name).to eq(:first_child)
      expect(child2.name).to eq(:second_child)
    end

    it "can add grandchildren via a block" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild)
        end
      end

      grandchild = root.children.first.children.first
      expect(grandchild.name).to eq(:grandchild)
    end

    it "can chain calls to add children" do
      root = Node.new(:root)
      child = Node.new(:child)
      second_child = Node.new(:second_child)

      root.add(child).add(second_child)

      expect(root.children).to include(child, second_child)
    end

    it "can find a decendant by name" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild) do
            Node.new(:greatgrandchild)
          end
        end
      end

      greatgrandchild = root.find(:greatgrandchild)
      expect(greatgrandchild.name).to eq(:greatgrandchild)
    end

    it "can find a decendant on another branch by name" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild) do
            Node.new(:greatgrandchild)
          end
        end
      end
      
      sibling = Node.new(:sibling)
      sibling.add(Node.new(:grandsibling))
      root.add(sibling)

      sibling_found = root.find(:sibling)
      expect(sibling_found).to eq(sibling)

      grandsibling = root.find(:grandsibling)
      expect(grandsibling.name).to eq(:grandsibling)
    end

    it "can return its immediate children" do
      root = Node.new(:root)
      child = Node.new(:child)
      grandchild = Node.new(:grandchild)

      child.add(grandchild)
      root.add(child)

      expect(root.children).to eq([child])
    end

    it "can list all its descendants" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild)
        end
      end 
      sibling = Node.new(:sibling)
      root.add(sibling)

      expect(root.descendants.count).to eq(3)
      expect(root.descendants).to include(sibling)
    end

    it "can find the root" do
      root = Node.new(:root)
      child = Node.new(:child)
      grandchild = Node.new(:grandchild)

      child.add(grandchild)
      root.add(child)

      expect(grandchild.root).to eq(root)
    end

    it "knows who its parent is" do
      root = Node.new(:root)
      child = Node.new(:child)
      grandchild = Node.new(:grandchild)

      child.add(grandchild)
      root.add(child)

      expect(grandchild.parent).to eq(child)
    end

  end

  describe World do
    it "can be an empty world" do
      world = World.new(:world)

      expect(world).to be_instance_of(World)
    end
  end

  describe Room do
    before(:each) do
      @world = World.new(:world)
      @kitchen = Room.new(:kitchen)
      @den = Room.new(:den)

      @world.add(@kitchen).add(@den)
    end

    it "can be a room called 'kitchen' in the world" do
      world = World.new(:world) do
        Room.new(:kitchen)
      end
      
      expect(world.children.last.name).to eq(:kitchen)
    end 

    it "can have exits to other rooms" do
      @kitchen.exit_north = @den
      @den.exit_south = @kitchen

      expect(@kitchen.exit_north.name).to eq(:den)
    end

  end

  describe Item do
    it "can be an item called 'spoon' in kitchen " do
      world = World.new(:world) do
        Room.new(:kitchen) do
          Item.new(:spoon)
        end
      end

      spoon = world.children.last.children.last
      expect(spoon.name).to eq(:spoon)
    end
  end

  describe Player do
    before(:each) do
      @player = Player.new(:cody)
      @world = World.new(:world)
      @room = Room.new(:kitchen)
      @item = Item.new(:spoon)
    end

    it "can be a player called 'cody' in kitchen " do
      @room.add(@player)
      @world.add(@room)

      expect(@room.children).to include(@player)
    end

    it "can move an item from kitchen to player" do
      @room.add(@player).add(@item)
      @world.add(@room)
      expect(@room.children).to include(@item)

      @player.get(:spoon)
      expect(@player.children).to include(@item)
      expect(@room.children).to_not include(@item)
      expect(@item.parent).to eq(@player)
    end

    it "can move from room to room" do
      another_room = Room.new(:den)

      @room.add(@player)
      @world.add(@room)
      @world.add(another_room)

      @player.move_to(:den)
    end

  end

end
