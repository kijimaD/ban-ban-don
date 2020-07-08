class CharacterGraphics < Component
  WALK_FRAME = 300
  DAMAGE_FRAME = 4
  PADDING = 16
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]

  def initialize(game_object)
    super(game_object)
    @damage_frame = 0
    @image_array = gen_image_array
    @body = body_direction
  end

  def update
    if object.recently_shoot?
      object.direction = object.gun_angle
    end
    @body = body_direction
    @weapon = weapons.frame('ak47s.png')
  end

  def draw(viewport)
    if @damage_frame > 0
      @body = damage_flashing
      @weapon = damage_flashing
      @damage_frame -= 1
    end
    @body.draw(x - PADDING, y - PADDING, 1)
    draw_bounding_box if $debug
    if object.recently_shoot?
      draw_weapon
    end
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

  def body_direction
    i = (object.direction / 45) % 8
    state_image(@image_array[i])
    charas.frame(@anime.to_s + ".png")
  end

  def state_image(directional_graphics)
    dgs = directional_graphics
    stand_image = dgs[0]
    runs = [dgs[1], dgs[2]]

    if object.throttle_down
      if Gosu.milliseconds - (@last_flip || 0 ) > WALK_FRAME || different?(runs)
        @anime = runs.reject do |t|
          t == @anime
        end.sample
        @last_flip = Gosu.milliseconds
      end
    else
      @anime = stand_image
    end
  end

  def draw_weapon
    i = (object.direction / 45) % 8
    if i < 4
      weapon_z = 2
      @weapon.draw_rot(x + PADDING / 2, y + PADDING / 2, weapon_z, object.direction - 90, 0.5, 0.5, 1)
    else
      weapon_z = 0
      @weapon.draw_rot(x - PADDING / 2, y + PADDING / 2, weapon_z, object.direction + 90, 0.5, 0.5, -1)
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

  def different?(runs)
    runs.all? do |run|
      @anime != run
    end
  end

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
    @charas ||= Gosu::TexturePacker.load_json(
      Utils.media_path("#{object.character_parameter["name"]}_packed.json"))
  end

  def weapons
    @weapons ||= Gosu::TexturePacker.load_json(
      Utils.media_path('weapons_packed.json'))
  end
end
