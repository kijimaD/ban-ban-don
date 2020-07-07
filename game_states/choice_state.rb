class ChoiceState < GameState
  attr_accessor :menu_state, :cursor_x
  PADDING = 10
  IN_PADDING = 1
  COLOR = Gosu::Color::WHITE
  BACKGROUND = Gosu::Color::BLACK

  def initialize(messages, images)
    @messages = messages
    @images = images
    @cursor_x = 0
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
      @image = Gosu::Image.from_text(message, 20, options = {font: Utils.title_font})
      @image.draw(PADDING + i * 100,
                  PADDING,
                  10, 1.0, 1.0, COLOR)
    end
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbReturn && @menu_state
      @menu_state.choice_return << @cursor_x
      GameState.switch(@menu_state)
    end
    if id == Gosu::KbRight && can_move_right?
      @cursor_x += 1
    end
    if id == Gosu::KbLeft && can_move_left?
      @cursor_x -= 1
    end
  end

  def draw_cursor
    x1, y1 = cursor_coords
    $window.draw_rect(
      x1,
      y1,
      @image.width,
      @image.height,
      COLOR,
      1)
  end

  def draw_cursor_cover
    x1, y1 = cursor_coords
    $window.draw_rect(
      x1 + IN_PADDING,
      y1 + IN_PADDING,
      @image.width - IN_PADDING * 2,
      @image.height - IN_PADDING * 2,
      BACKGROUND,
      5)
  end

  def cursor_coords
    x1 = PADDING + @cursor_x * 100
    y1 = PADDING
    [x1, y1]
  end

  def can_move_right?
    @cursor_x < @messages.length - 1
  end

  def can_move_left?
    @cursor_x > 0
  end

end
