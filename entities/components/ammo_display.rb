class AmmoDisplay < Component
  WIDTH = 150
  HEIGHT = 100
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.33, 0, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
    @weapon_message = Gosu::Image.from_text(@character.weapon['name'], 20, options = {font: Utils.title_font})
  end

  def draw
    # draw_ammo_bg
    draw_ammo
    draw_weapon_type
    draw_weapon_bg
  end

  def draw_ammo
    x1, x2, y1, y2 = ammo_coords
    @character.number_ammo.times do |i|
      ammo_image.draw(x1 + PADDING * i, y1, 300)
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

  def draw_weapon_type
    x1, x2, y1, y2 = weapon_coords
    if @weapon_message
      @weapon_message.draw(x1, y1, 300, 1.0, 1.0, FONT_COLOR)
    end
  end

  def draw_weapon_bg
    x1, x2, y1, y2 = weapon_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      @weapon_message.width + PADDING, y1, BACKGROUND,
      @weapon_message.width + PADDING, @weapon_message.height + PADDING, BACKGROUND,
      x1, @weapon_message.height + PADDING, BACKGROUND,
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
    Gosu::Image.new(Utils.media_path('ammo.png'))
  end

end
