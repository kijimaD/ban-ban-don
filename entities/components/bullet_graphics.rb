class BulletGraphics < Component
  COLOR = Gosu::Color::WHITE

  def draw(viewport)
    $window.draw_quad(x - 3, y - 3, COLOR,
                      x + 3, y - 3, COLOR,
                      x - 3, y + 3, COLOR,
                      x + 3, y + 3, COLOR,
                      1)
  end

end
