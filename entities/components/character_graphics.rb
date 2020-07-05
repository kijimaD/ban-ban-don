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

  def image_num
    @graph ||= [["0-0", "0-1", "0-2"],
	         ["1-0", "1-1", "1-2"],
	         ["2-0", "2-1", "2-2"],
	         ["3-0", "3-1", "3-2"],
	         ["4-0", "4-1", "4-2"],
	         ["5-0", "5-1", "5-2"],
	         ["6-0", "6-1", "6-2"],
	         ["7-0", "7-1", "7-2"]]
  end

  def direction_graphics
    i = (object.direction / 45) % 7
    graph = image_num[i]
    state_image(graph[0], graph[1], graph[2])
    file = @flip.to_s + ".png"
    charas.frame(file)
  end

  def state_image(stand_image, run_image0, run_image1)
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

  def charas
    @@charas ||= Gosu::TexturePacker.load_json(
      Utils.media_path('charas.json'), :precise)
  end
end
