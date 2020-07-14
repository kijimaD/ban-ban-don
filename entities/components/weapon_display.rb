class WeaponDisplay < Component
  WIDTH = 80
  HEIGHT = 20
  PADDING = 10
  FONT_COLOR = Gosu::Color::WHITE
  BACKGROUND = Gosu::Color.new(255 * 0.66, 0, 0, 0)

  def initialize(object, object_pool, character)
    @object = object
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
  end

  def draw
    draw_weapon_type
    draw_weapon_bg
  end

  def draw_weapon_type
    x1, x2, y1, y2 = weapon_coords
    weapon_msg.draw(x1, y1, 300, 1.0, 1.0, FONT_COLOR)
  end

  def draw_weapon_bg
    x1, x2, y1, y2 = weapon_coords
    $window.draw_quad(
      x1 - PADDING, y1, BACKGROUND,
      x2 + PADDING, y1, BACKGROUND,
      x2 + PADDING, y2, BACKGROUND,
      x1 - PADDING, y2, BACKGROUND,
      200)
  end

  private

  def weapon_coords
    x1 = $window.width - WIDTH - PADDING
    x2 = $window.width - PADDING
    y1 = PADDING
    y2 = PADDING + HEIGHT
    [x1, x2, y1, y2]
  end

  def weapon_msg
    @weapon_message = Gosu::Image.from_text(@character.weapon['name'], 20, options = {font: Utils.title_font})
  end

end
