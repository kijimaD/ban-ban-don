class ChoiceState < GameState
  attr_accessor :menu_state, :cursor_x
  PADDING = 10
  IN_PADDING = 1
  COLOR = Gosu::Color::WHITE
  BACKGROUND = Gosu::Color::WHITE
  Z = 20

  def initialize(messages, images, target)
    @messages = messages
    @images = images
    @target = target
    @cursor_x = 0
    image_sample
  end

  def enter
  end

  def leave
  end

  def draw
    @menu_state.draw
    draw_message
    draw_cursor
    draw_cursor_cover
  end

  def update
  end

  def draw_message
    @messages.each_with_index do |message, i|
      image = @images.frame(message[0].to_s + ".png")
      image.draw($window.width / 2 - 2 * image.width + i * (image.width + IN_PADDING),
                   $window.height / 2 - image.height,
                  Z, 1.0, 1.0, COLOR)
    end
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbReturn && @menu_state
      @menu_state.choice_return[@target] = @messages[@cursor_x][1]
      ok_sound.play
      GameState.switch(@menu_state)
    end
    if id == Gosu::KbRight && can_move_right?
      @cursor_x += 1
      move_sound.play
    end
    if id == Gosu::KbLeft && can_move_left?
      @cursor_x -= 1
      move_sound.play
    end
  end

  def draw_cursor
    x1, y1 = cursor_coords
    $window.draw_rect(
      x1 - IN_PADDING,
      y1 - IN_PADDING,
      @image_sample.width + IN_PADDING * 2,
      @image_sample.height + IN_PADDING * 2,
      COLOR,
      Z - 1)
  end

  def draw_cursor_cover
    x1, y1 = cursor_coords
    $window.draw_rect(
      x1 + IN_PADDING,
      y1 + IN_PADDING,
      @image_sample.width - IN_PADDING * 2,
      @image_sample.height - IN_PADDING * 2,
      BACKGROUND,
      Z - 1)
  end

  def cursor_coords
    x1 = $window.width / 2 - 2 * @image_sample.width + @cursor_x * (@image_sample.width + IN_PADDING)
    y1 = $window.height / 2 - @image_sample.height
    [x1, y1]
  end

  def can_move_right?
    @cursor_x < @messages.length - 1
  end

  def can_move_left?
    @cursor_x > 0
  end

  def image_sample
    @image_sample = @images.frame(@messages[0][0] + ".png")
  end

  def move_sound
    @@move_sound ||= Gosu::Sample.new(Utils.media_path_sound('cursor_move.wav'))
  end

  def ok_sound
    @@ok_sound ||= Gosu::Sample.new(Utils.media_path_sound('cursor_ok.wav'))
  end

end
