dork
====

A tree based text adventure game engine, inspired by Infocom's Zork.

Dork is a toy project designed to explore n-ary trees.  In Dork, every object is represented as a `Node` and, except for the `World` node, is contianed within another `Node`.  As a `Player` moves from room to room, she is simply becoming a child of a new `Room` node.  Similarly, as an `Item` is picked up by a `Player`, it is simply moved from the `Room` node (or, if it is conatined in box or cabinent, another `Item` node) onto the `Player`.  Game conditions are held in a special `Script` node that checks for various conditions to unlock other areas of the game.

```
+---------------------------------------------+
|                     World                   |
+------+---------------+--------------+-------+
       |               |              |        
+------v------+ +------v------+ +-----v-------+
|   Room      | |   Room      | |   Room      |
+--+-------+--+ +---+---------+ +-------------+
   |       |        |                          
+--v-+ +---v-+  +---v--+                       
|Item| |Item |  |Player|                       
|    | |     |  |      |                       
+----+ +--+--+  +--+---+-----+                 
          |        |         |                 
       +--v--+  +--v---+ +---v--+              
       |Item |  | Item | | Item |              
       |     |  |      | |      |              
       +-----+  +------+ +------+          
```

[The engine](https://github.com/codyduval/dork/blob/master/lib/dork.rb) consists of a handful of classes in a single file.  You can see a [sample game script](https://github.com/codyduval/dork/blob/master/game_scripts/sample.yml) which creates a small world where the player needs to find all of the tools and ingredients to make and eat scrambled eggs.

And Rspec tests for the engine are [here](https://github.com/codyduval/dork/blob/master/spec/lib/dork_spec.rb).
