class CharacterGraphics < Component
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]
  def initialize(game_object)
    super(game_object)
    @body = units.frame('tank1_body.png')
    @shadow = units.frame('tank1_body_shadow.png')
    @gun = units.frame('tank1_dualgun.png')
  end

  def draw(viewport)
    @shadow.draw_rot(x - 1, y - 1, 0, object.direction)
    @body.draw_rot(x, y, 1, object.direction)
    @gun.draw_rot(x, y, 2, object.gun_angle)
    draw_bounding_box if $debug
  end

  def draw_bounding_box
    $window.rotate(object.direction, x, y) do
      w = @body.width
      h = @body.height
      $window.draw_quad(
        x - w / 2, y - h / 2, Gosu::Color::RED,
        x + w / 2, y - h / 2, Gosu::Color::RED,
        x + w / 2, y + h / 2, Gosu::Color::RED,
        x - w / 2, y + h / 2, Gosu::Color::RED,
        100)
    end
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json(
      Utils.media_path('ground_units.json'), :precise)
  end
end
