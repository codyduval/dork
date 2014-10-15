$: << '.'
require "dork"
require "yaml"

eggy = File.open('../game_scripts/sample.yml', 'r')
@world = YAML.load(eggy)
eggy.close
@world.player.play

