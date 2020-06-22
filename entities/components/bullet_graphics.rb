class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def initialize(object)
    super(object)
    @object = object
  end

  def draw(viewport)
    bullet(@object.weapon['bullet_image']).draw_rot(x - 4, y - 4, 1, @object.gun_angle)
  end

  private

  def bullet(image)
    @bullet = bullets.frame(image)
  end

  def bullets
    @@bullets ||= Gosu::TexturePacker.load_json(
      Utils.media_path('bullets.json'))
  end

end
