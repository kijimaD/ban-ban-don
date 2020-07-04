require 'singleton'
class PauseState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text("Game Paused", 60, options = { font: Utils.title_font})
  end

  def enter
    music.play(true)
    music.volume = 1
    @mouse_coords = [$window.mouse_x, $window.mouse_y]
  end

  def leave
    music.volume = 0
    music.stop
    $window.mouse_x, $window.mouse_y = @mouse_coords
  end

  def music
    @@music ||= Gosu::Song.new(
      Utils.media_path_sound('menu_music.wav'))
  end

  def draw
    @play_state.draw
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 4 - @message.height,
      1000)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbEscape
      GameState.switch(@play_state)
    end
  end

end
