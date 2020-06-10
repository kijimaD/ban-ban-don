class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def initialize(object)
    super(object)
    @object = object
  end

  def draw(viewport)
    image(@object.weapon.bullet_image).draw(x - 8, y - 8, 1)
  end

  private

  def image(image)
    @@bullet = Gosu::Image.new(
      $window, Utils.media_path(image), false)
  end

end
