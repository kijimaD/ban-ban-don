require 'singleton'
class PauseState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @max_player_character = 2
    @max_difficulty = 2
    @pointer_x = 0
    @pointer_y = 0
    @buttons = [@pointer_x, @pointer_y]
  end

  def enter

  end

  def update
  end

  def draw
    @test = Gosu::Image.from_text(
      $window, "x,y = #{@pointer_x}, #{@pointer_y}",
      Gosu.default_font_name, 30)
    @test.draw(100, 100, 100)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbUp
      cursor_up
    end
    if id == Gosu::KbDown
      cursor_down
    end
    if id == Gosu::KbRight
      cursor_right
    end
    if id == Gosu::KbLeft
      cursor_left
    end
  end

  def cursor_up
    @pointer_y += 1
  end

  def cursor_down
    @pointer_y -= 1
  end

  def cursor_right
    @pointer_x += 1
  end

  def cursor_left
    @pointer_x -= 1
  end

  # def decision
  # end

end
