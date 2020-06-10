class CharacterGraphics < Component
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]
  def initialize(game_object)
    super(game_object)
    @body = image('sirase.png') # TODO: prepare direction image. This image is dummy.
    # @shadow = units.frame('tank1_body_shadow.png')
    @gun = units.frame('tank1_dualgun.png')
  end

  def draw(viewport)
    # @shadow.draw_rot(x - 1, y - 1, 0, object.direction)
    @body.draw(x - 32, y - 32, 1)
    @gun.draw_rot(x, y, 2, object.direction) # TODO: prepare 4? direction image(same with @body)
    # draw_bounding_box if $debug
  end

  def draw_bounding_box
    i = 0
    object.box.each_slice(2) do |x, y|
      color = DEBUG_COLORS[i]
      $window.draw_triangle(
        x - 3, y - 3, color,
        x,     y,     color,
        x + 3, y - 3, color,
        100)
      i = (i + 1) % 4
    end
  end

  def width
    @body.width
  end

  def height
    @body.height
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json(
      Utils.media_path('ground_units.json'), :precise)
  end

  def image(image)
    @@bullet = Gosu::Image.new(
      $window, Utils.media_path(image), false)
  end
end
