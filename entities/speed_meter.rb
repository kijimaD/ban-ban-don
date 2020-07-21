class SpeedMeter
  WIDTH = 30
  HEIGHT = 80
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.33, 0, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE

  def initialize(object, object_pool, character)
    @object = object
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
  end

  def draw
    if $debug
      speed_image
    end
  end

  def speed_image
    x1, x2, y1, y2 = speed_coords
    $window.draw_rect(x1, y1, @character.physics.speed * 10, 3, FONT_COLOR, HUD::Z)
  end

  def draw_speed_bg
    x1, x2, y1, y2 = speed_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      HUD::Z - 1
    )
  end

  def speed_coords
    x1 = PADDING
    x2 = $window.width - PADDING
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

end
