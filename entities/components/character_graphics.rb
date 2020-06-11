class CharacterGraphics < Component
  WALK_FRAME = 300
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]
  def initialize(game_object)
    super(game_object)
    @body = charas.frame('chara2.png')
    @shadow = units.frame('tank1_body_shadow.png')
    @gun = units.frame('tank1_dualgun.png')
  end

  def update()
    @body = direction_graphics
  end

  def draw(viewport)
    # @shadow.draw_rot(x - 1, y - 1, 0, object.direction)
    @body.draw(x - 16, y - 16, 1)
    # @gun.draw_rot(x, y, 2, object.direction)
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

  def direction_graphics
    case object.direction
    when 0 then
      if object.throttle_down == true
        num = @flip || 2
        if Gosu.milliseconds - (@last_flip || 0) > WALK_FRAME
          if @flip == 19
            @flip = 21
          else
            @flip = 19
          end
          @last_flip = Gosu.milliseconds
        end
      else
        num = 20
      end
    when 45 then
      num = 23
    when 90 then
      num = 14
    when 135 then
      num = 11
    when 180 then
      num = 2
    when 225 then
      num = 5
    when 270 then
      num = 8
    when 315 then
      num = 17
    else
      num = 20
    end
    @prev_num = num
    file = "chara" + num.to_s + ".png"
    body = charas.frame(file)
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json(
      Utils.media_path('ground_units.json'), :precise)
  end

  def charas
    @@charas = Gosu::TexturePacker.load_json(
      Utils.media_path('charas.json'), :precise)
  end
end
