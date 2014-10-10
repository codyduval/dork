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
    end

    it "can add a 2 siblings via a block" do
      root = Node.new(:root) do
        [Node.new(:first_child), Node.new(:second_child)]
      end

      expect(root.children.count).to eq(2)

      child = root.children.first
      expect(child.parent).to eq(root)
      expect(child.name).to eq(:first_child)
    end

    it "can add grandchildren via a block" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild)
        end
      end

      expect(root.children.first.children.count).to eq(1)
    end

    it "can find a node by name" do
      root = Node.new(:root) do
        Node.new(:child) do
          Node.new(:grandchild) do
            Node.new(:greatgrandchild)
          end
        end
      end
      root.add(Node.new(:sibling))

      greatgrandchild = root.find(:greatgrandchild)
      expect(greatgrandchild.name).to eq(:greatgrandchild)

      sibling = root.find(:sibling)
      expect(sibling.name).to eq(:sibling)
    end

  end

  describe World do
    it "can be an empty world" do
      world = World.new(:root)
      expect(world).to be_instance_of(World)
    end

    it "can list its children" do
      world = World.new(:root) do
        Room.new(:kitchen) do
          Item.new(:fork)
        end
      end

      expect(world.children.count).to eq(2)
    end
  end

  describe Room do
    it "can be a room called 'kitchen' in the world" do
    end 
  end

  describe Item do
    it "can be an item called 'spoon' in kitchen " do
    end
  end

  describe Player do
    it "can be a player called 'cody' in kitchen " do
    end

    it "can move an item from kitchen to player in same room" do
    end

  end

end
