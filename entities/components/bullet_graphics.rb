class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def initialize(object)
    super(object)
    @object = object
  end

  def draw(viewport)
    bullet.draw_rot(x - 4, y - 4, depth, @object.gun_angle)
    Utils.mark_corners(object.box) if $debug
  end

  def height
    @h ||= bullet.height
  end

  def width
    @w ||= bullet.width
  end

  private

  def center_x
    @center_x ||= x - width / 2
  end

  def center_y
    @center_y ||= y - height / 2
  end

  def bullet
    @bullet ||= bullets.frame(@object.weapon['bullet_image'])
  end

  def bullets
    @@bullets ||= Gosu::TexturePacker.load_json(
      Utils.media_path('bullets_packed.json'))
  end

end
