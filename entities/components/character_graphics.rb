class CharacterGraphics < Component
  WALK_FRAME = 300
  DAMAGE_FRAME = 4
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]

  def initialize(game_object)
    super(game_object)
    @body = charas.frame('4-0.png')
    @damage_frame = 0
    @image_array = gen_image_array
  end

  def update()
    @body = direction_graphics
  end

  def draw(viewport)
    if @damage_frame > 0
      @body = damage_flashing
      @damage_frame -= 1
    end
    @body.draw(x - 16, y - 16, 1)
    draw_bounding_box if $debug
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
    i = (object.direction / 45) % 7
    graphic = @image_array[i]
    state_image(graphic)
    file = @flip.to_s + ".png"
    charas.frame(file)
  end

  def state_image(graphic)
    stand_image = graphic[0]
    run_image0 = graphic[1]
    run_image1 = graphic[2]
    if object.throttle_down == true
      if Gosu.milliseconds - (@last_flip || 0 ) > WALK_FRAME ||
         (@flip != run_image0 && @flip != run_image1)
        if @flip == run_image0
          @flip = run_image1
        else
          @flip = run_image0
        end
        @last_flip = Gosu.milliseconds
      end
    else
      @flip = stand_image
    end
  end

  def damage_flashing
    fill = Magick::TextureFill.new(Magick::ImageList.new("plasma:fractal") {self.size = '1x1'})
    bg = Magick::Image.new(1, 1, fill)
    Gosu::Image.new(bg)
  end

  def damage
    @damage_frame += DAMAGE_FRAME
  end

  private

  def gen_image_array
    goal = Array.new(8).map{Array.new(2)}
    for direction in 0..7 do
      for i in 0..2 do
        goal[direction][i] = direction.to_s + "-" + i.to_s
      end
    end
    goal
  end

  def charas
    @@charas ||= Gosu::TexturePacker.load_json(
      Utils.media_path('charas.json'), :precise)
  end
end
