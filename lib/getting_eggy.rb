$: << '.'
require "dork"
require "yaml"

eggy = File.open('sample.yml', 'r')
@world = YAML.load(eggy)
eggy.close
@world.player.play


