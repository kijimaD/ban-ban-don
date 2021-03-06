class AmmoDisplay < Component
  WIDTH = 60
  HEIGHT = 70
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.33, 0, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE
  attr_accessor :character

  def initialize(args)
    @hud = args[:hud]
    @object_pool = args[:object_pool]
    @character = args[:character]
    @last_update = 0
  end

  def update
  end

  def draw
    draw_ammo
  end

  def draw_ammo
    x1, x2, y1, y2 = coords
    @character.number_ammo.times do |i|
      image.draw(x1 + PADDING * i, y1, HUD::Z)
    end
  end

  def draw_ammo_bg
    x1, x2, y1, y2 = coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      HUD::Z - 1)
  end

  private

  def coords
    x1 = WIDTH + PADDING
    x2 = 0
    y1 = $window.height - HEIGHT - PADDING
    y2 = 0
    [x1, x2, y1, y2]
  end

  def image
    @@image ||= @hud.images.frame('ammo.png')
  end

end
