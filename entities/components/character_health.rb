class CharacterHealth < Health
  attr_accessor :health, :max_health
  PADDING = 20
  WIDTH = 40
  HEIGHT = 3
  COLOR = Gosu::Color::GREEN
  BACKGROUND = Gosu::Color::BLACK

  def initialize(object, object_pool)
    super(object, object_pool, 100, true)
    @object = object
    @object_pool = object_pool
    @health_updated = true
    @last_damage = Gosu.milliseconds
  end

  def update
  end

  def draw(viewport)
    x1, x2, y1, y2 = coords
    if object.input.is_a?(AiInput)
    $window.draw_quad(
        x1, y1, BACKGROUND,
        x2, y1, BACKGROUND,
        x2, y2, BACKGROUND,
        x1, y2, BACKGROUND,
      )
    if object.health.health > 0
      gauge_len = WIDTH * (object.health.health.to_f / object.health.initial_health.to_f)
      x2 = x1 + gauge_len
      $window.draw_quad(
        x1, y1, COLOR,
        x2, y1, COLOR,
        x2, y2, COLOR,
        x1, y2, COLOR,
      )
    end
    end
  end

  def coords
    x1 = x - PADDING
    x2 = x - PADDING + WIDTH
    y1 = y - HEIGHT - PADDING * 2
    y2 = y + HEIGHT - PADDING * 2
    [x1, x2, y1, y2]
  end

end
