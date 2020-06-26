require 'gosu'
require 'rmagick'
require 'perlin_noise'
require 'gosu_texture_packer'
require 'singleton'

# TODO: I have no idea why can't load Powerup first.(If not this part, ocuur error: uninitialized constant Powerup(NameError))
require './entities/game_object'
require './entities/powerups/powerup'
require './game_states/game_state'
require './game_states/play_state'
require './game_states/demo_state'
# ---

root_dir = File.dirname(__FILE__)
require_pattern = File.join(root_dir, '**/*.rb')
@failed = []

# Dynamically require everything
Dir.glob(require_pattern).each do |f|
  next if f.end_with?('/main.rb')
  begin
    require_relative f.gsub("#{root_dir}/", '')
  rescue
    # May fail if parent class not required yet
    @failed << f
  end
end

# Retry unresolved requires
@failed.each do |f|
  require_relative f.gsub("#{root_dir}/", '')
end

# $debug = true
$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
