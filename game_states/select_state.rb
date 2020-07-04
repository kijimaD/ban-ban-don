# coding: utf-8
class SelectState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @player_characters = ['Pawapuro', 'Ishinaka', 'Shirase', 'Haibara']
    @difficulties = ['easy', 'normal', 'hard', 'powerful']
    @cursor_x = 0
    @cursor_y = 0
    @cursor_x_save = Array.new(4, 0)
  end

  def enter
  end

  def continue
  end

  def update
    $window.caption = 'ばんばんどーん！SELECT' << "[FPS: #{Gosu.fps}]"
    @settings_sentence = Gosu::Image.from_text($window,
      "      currnet x, y = #{@cursor_x}, #{@cursor_y} save: #{@cursor_x_save}\n
      Character: #{gen_choises(@player_characters, 0)}
      Difficulty: #{gen_choises(@difficulties, 1)}
      #{gen_button(2, "戻る")}
      #{gen_button(3, "決定")}",
      Gosu.default_font_name, 30)
  end

  def draw
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
    if id == Gosu::KbReturn && @cursor_y == 2 # continue
      GameState.switch(@play_state)
    end
    if id == Gosu::KbReturn && @cursor_y == 3 # save
      GameState.switch(@play_state)
    end
  end

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if Utils.button_down?(b)
    end
    false
  end

  def cursor_up
    if @cursor_y > 0
      @cursor_x_save[@cursor_y] = @cursor_x
      @cursor_y -= 1
      @cursor_x = @cursor_x_save[@cursor_y]
    end
  end

  def cursor_down
    if @cursor_y < 3
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

  def gen_choises(input_array, goal_y)
    content = ""
    input_array.each_with_index do |column, i|
      if i == @cursor_x && @cursor_y == goal_y
        content = "#{content} ▼[#{column}]"
      elsif i == @cursor_x_save[goal_y]  && @cursor_y != goal_y
        content = "#{content} [#{column}]"
      else
        content = "#{content} #{column}"
      end
    end
    content
  end

  def gen_button(goal_y, button)
    if @cursor_y == goal_y
      print_decision = "▼#{button}"
    else
      print_decision = "#{button}"
    end
    print_decision
  end

end
