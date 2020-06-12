class AmmoDisplay < Component
  WIDTH = 150
  HEIGHT = 60
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.33, 0, 0, 0)
  FONT_COLOR = Gosu::Color::GREEN

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
    @ammo_message = Gosu::Image.from_text(
      $window, ammo_image,
      Gosu.default_font_name, 60)
    @weapon_message = Gosu::Image.from_text(
      $window, @character.weapon['name'],
      Gosu.default_font_name, 20)
  end

  def draw
    draw_ammo_bg
    draw_ammo
    draw_weapon_type
  end

  def draw_ammo
    x1, x2, y1, y2 = ammo_coords
    if @ammo_message
      @ammo_message.draw(x1, y1, 300, 1.0, 1.0, FONT_COLOR)
    end
  end

  def draw_weapon_type
    x1, x2, y1, y2 = weapon_coords
    if @weapon_message
      @weapon_message.draw(x1, y1, 300, 1.0, 1.0, FONT_COLOR)
    end
  end

  def draw_ammo_bg
    x1, x2, y1, y2 = ammo_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      200)
  end

  def ammo_coords
    x1 = PADDING
    x2 = $window.width - PADDING
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def weapon_coords
    x1 = PADDING
    x2 = $window.width - PADDING
    y1 = PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def ammo_image
    "i" * @character.number_ammo
  end

end
