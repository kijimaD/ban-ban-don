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
    @chara_json = Utils.load_json("character_graphics.json")
  end

  def update()
    @body = direction_graphics
    if object.number_ammo == 0 && object.number_magazine > 0
      object.reload
    end
  end

  def draw(viewport)
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
    @chara_json['sirase']['graphs'].each_with_index do |graph, i|
      if object.direction == i * 45
        each_image(graph[0], graph[1], graph[2])
        break
      end
    end
    @prev_num = @num
    file = "chara" + @num.to_s + ".png"
    charas.frame(file)
  end

  def each_image(stand_image, run_image0, run_image1)
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

  def charas
    @@charas ||= Gosu::TexturePacker.load_json(
      Utils.media_path('charas.json'), :precise)
  end
end
