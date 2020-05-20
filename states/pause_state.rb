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
    @cursor_x_save = Array.new(3, 0)
  end

  def enter

  end

  def continue

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

    if @cursor_y == 2
      @print_decision = '<決定\>'
    else
      @print_decision = "決定"
    end

    @cursor_location = Gosu::Image.from_text(
      $window, "currnet x, y = #{@cursor_x}, #{@cursor_y} save: #{@cursor_x_save}",
      Gosu.default_font_name, 30)

    @settings_sentence = Gosu::Image.from_text(
      $window, "character: #{@print_character}\n
                difficulty: #{@print_difficulty}\n
                #{@print_decision}",
      Gosu.default_font_name, 30)

    @print_character = ""
    @print_difficulty = ""
  end

  def draw
    @cursor_location.draw(0, 0, 0)
    @settings_sentence.draw(0, 50, 0)
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
    if @cursor_y > 0
      @cursor_x_save[@cursor_y] = @cursor_x
      @cursor_y -= 1
      @cursor_x = @cursor_x_save[@cursor_y]
    end
  end

  def cursor_down
    if @cursor_y < 2
      @cursor_x_save[@cursor_y] = @cursor_x
      @cursor_y += 1
      @cursor_x = @cursor_x_save[@cursor_y]
    end
  end

  def cursor_right
    if @cursor_x < 3
      @cursor_x += 1
    end
  end

  def cursor_left
    if @cursor_x > 0
      @cursor_x -= 1
    end
  end

  # def decision
  # end

end
