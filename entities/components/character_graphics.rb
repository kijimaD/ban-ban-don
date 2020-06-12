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
      each_image(20, 19, 21)
    when 45 then
      each_image(23, 22, 24)
    when 90 then
      each_image(14, 15, 13)
    when 135 then
      each_image(11, 10, 12)
    when 180 then
      each_image(2, 1, 3)
    when 225 then
      each_image(5, 4, 6)
    when 270 then
      each_image(8, 7, 9)
    when 315 then
      each_image(17, 16, 18)
    # else
      # @num = 20
    end
    @prev_num = @num
    file = "chara" + @num.to_s + ".png"
    body = charas.frame(file)
  end

  def each_image(stand_image, run_image0, run_image1)
    # degrees = [0, 45, 90, 135, 180, 225, 270, 315]
    if object.throttle_down == true
      if Gosu.milliseconds - (@last_flip || 0 ) > WALK_FRAME ||
         (@flip != run_image0 && @flip != run_image1)
        if @flip == run_image0
          @flip = run_image1
        else
          @flip = run_image0
        end
        @num = @flip
        @last_flip = Gosu.milliseconds
      end
    else
      @num = stand_image
    end
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
