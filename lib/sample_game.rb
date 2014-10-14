$: << '.'
require "dork"
require "yaml"

player = Dork::Player.new(:cody)

@world = Dork::World.new(:world)
  kitchen = Dork::Room.new(:kitchen, "You are in a modern KITCHEN. There is a door to the south that leads to a DINING room.")
    kitchen.exit_south = :dining
    cabinet = Dork::Item.new(:cabinet, "A CABINET.")
      bowl = Dork::Item.new(:bowl, "A mixing BOWL.")
      plate = Dork::Item.new(:plate, "A dinner PLATE.")
      pan = Dork::Item.new(:pan, "A PAN for cooking things.")
    fridge = Dork::Item.new(:refrigerator, "A REFRIGERATOR.")
      eggs = Dork::Item.new(:eggs, "A WHISK for beating or mixing things.")
    drawer = Dork::Item.new(:drawer, "A DRAWER.")
      whisk = Dork::Item.new(:whisk, "A WHISK for beating or mixing things.")
      fork = Dork::Item.new(:fork, "A FORK for putting food into your mouth.")
    stove = Dork::Item.new(:stove, "A STOVE for cooking.")
    uncooked_scrambled_eggs = Dork::Item.new(:uncooked, "UNCOOKED scrambled egg mixture.")
    cooked_eggs = Dork::Item.new(:cooked, "Perfectly COOKED scrambled eggs on plate.")

  dining = Dork::Room.new(:dining, "You are in a small dining room. There is door to the north that leads to the KITCHEN.")
    table = Dork::Item.new(:table, "A dining room TABLE.")

#scripts
  mix_eggs = Dork::Script.new(:mix_eggs)
  mix_eggs.script_keys = ["mix eggs", "scramble eggs in bowl", "mix eggs in bowl", "scramble eggs"]
  mix_eggs.failure_message = "Hmm, that sounds like a good idea, but you don't have everything you need to do it."
  mix_eggs.success_message = "With verve and aplomb, you crack open two eggs into the bowl and scramble them together. You now see a bowl of UNCOOKED egg mixture on the counter." 
  mix_eggs.conditions = ["player.has(:whisk)", "player.has(:eggs)", "player.has(:bowl)"]
  mix_eggs.actions = ["root.find(:eggs).visible = false", "root:find(:uncooked.visible = true" ]

  cook_eggs = Dork::Script.new(:cook_eggs)
  cook_eggs.script_keys = ["cook eggs", "cook eggs on stove", "put eggs in pan", "use stove to cook eggs", "turn on stove"]
  cook_eggs.failure_message = "Hmm, that sounds like a good idea, but you don't have everything you need to do it."
  cook_eggs.success_message = "You turn on the stove, pour the eggs into the pan, and carefully cook the eggs to perfection.  You put them on your plate." 
  cook_eggs.conditions = ["player.has(:pan)", "player.has(:uncooked)", "player.has(:plate)"]
  cook_eggs.actions = ["root.find(:uncooked).visible = false", "root.find(:cooked.visible = true", "root.find(:plate).visible = false" ]

drawer.add(whisk).add(fork)
fridge.add(eggs)
cabinet.add(bowl).add(plate).add(pan)
kitchen.add(player).add(cabinet).add(stove).add(fridge).add(drawer).add(uncooked_scrambled_eggs).add(cooked_eggs)
kitchen.add(mix_eggs).add(cook_eggs)
@world.add(kitchen).add(dining)


#player.play
