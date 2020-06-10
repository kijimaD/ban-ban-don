class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def draw(viewport)
    image.draw(x - 8, y - 8, 1)
  end

  private

  def image
    @@bullet ||= Gosu::Image.new(
      $window, Utils.media_path('bullet.png'), false)
  end

end
