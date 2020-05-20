# coding: utf-8
require 'singleton'
class PauseState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @player_characters = ["Pawapuro", "Ishinaka", "Shirase", "Haibara"]
    @difficulties = ["easy", "normal", "hard", "powerful"]
    @cursor_x = 0
    @cursor_y = 0
    @buttons = [@cursor_x, @cursor_y]
    @cursor_x_save = Array.new(2, 0)
  end

  def enter

  end

  def update
    @player_characters.each_with_index do |chara, i|
      if i == @cursor_x && @cursor_y == 0
        @print_character = "#{@print_character}<#{chara}>"
      else
        @print_character = "#{@print_character} #{chara}"
      end
    end

    @difficulties.each_with_index do |difficult, i|
      if i == @cursor_x && @cursor_y == 1
        @print_difficulty = "#{@print_difficulty}<#{difficult}>"
      else
        @print_difficulty = "#{@print_difficulty} #{difficult}"
      end
    end

    @cursor_location = Gosu::Image.from_text(
      $window, "x, y = #{@cursor_x}, #{@cursor_y} save: #{@cursor_x_save}",
      Gosu.default_font_name, 30)

    @player_character_row = Gosu::Image.from_text(
      $window, "#{@print_character}",
      Gosu.default_font_name, 30)

    @difficulty_row = Gosu::Image.from_text(
      $window, "#{@print_difficulty}",
      Gosu.default_font_name, 30)

    @print_character = ""
    @print_difficulty = ""
  end

  def draw
    @cursor_location.draw(0, 0, 0)
    @player_character_row.draw(0, 50, 0)
    @difficulty_row.draw(0, 100, 0)
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
    @cursor_x_save[@cursor_y] = @cursor_x
    @cursor_y -= 1
    @cursor_x = @cursor_x_save[@cursor_y]
  end

  def cursor_down
    @cursor_x_save[@cursor_y] = @cursor_x
    @cursor_y += 1
    @cursor_x = @cursor_x_save[@cursor_y]
  end

  def cursor_right
    @cursor_x += 1
  end

  def cursor_left
    @cursor_x -= 1
  end

  # def decision
  # end

end
