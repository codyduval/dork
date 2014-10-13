$: << '.'
require "dork"

player = Dork::Player.new(:cody)
world = Dork::World.new(:world) do
  Dork::Room.new(:kitchen) do
    [Dork::Item.new(:spoon), player]
  end
end

player.play
