class AmmoDisplay
  WIDTH = 150
  HEIGHT = 100
  PADDING = 10
  BACKGROUND = Gosu::Color.new(1, 0, 0, 0)

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
  end

  def draw
    x1, x2, y1, y2 = ammo_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      200)
    draw_ammo
  end

  def draw_ammo
    @message = Gosu::Image.from_text(
      $window, ammo_image,
      Gosu.default_font_name, 100)
    if @message
      @message.draw(
        $window.width / 2 - @message.width / 2,
        $window.height / 2 - @message.height / 2,
        300)
    end
  end

  def ammo_coords
    x1 = $window.width - WIDTH - PADDING
    x2 = $window.width - PADDING
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def ammo_image
    "i" * @character.number_ammo
  end

end
