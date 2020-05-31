class SpeedMeter < Component
  WIDTH = 30
  HEIGHT = 120
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.33, 0, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
    @message = Gosu::Image.from_text(
      $window, speed_format,
      Gosu.default_font_name, 60)
  end

  def draw
    draw_speed
    # draw_speed_bg
  end

  def draw_speed
    x1, x2, y1, y2 = speed_coords
    if @message
      @message.draw(x1, y1, 300, 1.0, 1.0, FONT_COLOR)
    end
  end

  def draw_speed_bg
    x1, x2, y1, y2 = speed_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      200
    )
  end

  def speed_coords
    x1 = PADDING
    x2 = $window.width - PADDING
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def speed_format
    "i" * @character.physics.speed
  end

end
