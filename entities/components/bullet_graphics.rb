class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def initialize(object)
    super(object)
    @object = object
  end

  def draw(viewport)
    image(@object.weapon['bullet_image']).draw_rot(x - 8, y - 8, 1, @object.gun_angle)
  end

  private

  def image(image)
    @@bullet = Gosu::Image.new(Utils.media_path(image))
  end

end
