class Map
  MAP_WIDTH = 10
  MAP_HEIGHT = 10
  TILE_WIDTH = 256
  TILE_HEIGHT = 128
  OFFSET_X = MAP_WIDTH * TILE_WIDTH / 2

  def self.bounding_box
    center = [MAP_WIDTH * TILE_WIDTH / 2,
              MAP_HEIGHT * TILE_HEIGHT / 2]
    half_dimension = [MAP_WIDTH * TILE_WIDTH,
                      MAP_HEIGHT * TILE_HEIGHT]
    AxisAlignedBoundingBox.new(center, half_dimension)
  end

  def initialize(object_pool)
    load_tiles
    load_walls
    @object_pool = object_pool
    object_pool.map = self
    @map = generate_fix_map(:parking)
    # generate_trees
    # generate_boxes
    # generate_powerups
  end

  def draw(viewport, character)
    viewport[0] = viewport[0] / TILE_WIDTH
    viewport[1] = viewport[1] / TILE_WIDTH
    viewport[2] = viewport[2] / TILE_HEIGHT
    viewport[3] = viewport[3] / TILE_HEIGHT
    x0, x1, y0, y1 = viewport.map(&:to_i)
    (x0-20..x1+20).each do |x|
      (y0-20..y1+20).each do |y|
        map_x = (y - x) * TILE_HEIGHT + OFFSET_X
        map_y = (y + x) * (TILE_HEIGHT / 2)
        wall_depth = (x + y)
        if @map[:floor][x]
          tile = @map[:floor][x][y]
          if tile
            tile.draw(map_x, map_y, 0)
          end
        end
        if @map[:wall_ns][x]
          ns_wall = @map[:wall_ns][x][y]
          if ns_wall
            ns_wall.draw(map_x + TILE_WIDTH / 2, (map_y + TILE_HEIGHT / 2) - ns_wall.height, wall_depth)
          end
        end
        if @map[:wall_we][x]
          we_wall = @map[:wall_we][x][y]
          if we_wall
            we_wall.draw(map_x, (map_y + TILE_HEIGHT / 2) - we_wall.height, wall_depth)
          end
        end
        if @map[:ceiling][x]
          ceiling = @map[:ceiling][x][y]
          if ceiling
            ceiling.draw(map_x, (map_y + TILE_HEIGHT / 2) - 256, 100 + wall_depth)
          end
        end
      end
    end
  end

  def spawn_points(max)
    @spawn_points = (0..max).map do
      find_spawn_point
    end
    @spawn_points_pointer = 0
  end

  def spawn_point
    @spawn_points[(@spawn_points_pointer += 1) % @spawn_points.size]
  end

  def can_move_to?(x, y)
    tile = tile_at(x, y)
    tile && tile != @water
  end

  def can_through_bullet?(x, y)
    tile = tile_at(x, y)
    tile && tile != @water
  end

  def movement_penalty(x, y)
    tile = tile_at(x, y)
    case tile
    when @sand
      0.33
    else
      0
    end
  end

  def generate_trees
    noises = Perlin::Noise.new(2)
    contrast = Perlin::Curve.contrast(
      Perlin::Curve::CUBIC, 2)
    trees = 0
    target_trees = rand(30..50)
    while trees < target_trees do
      x = rand(0..MAP_WIDTH * TILE_WIDTH + OFFSET_X)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT)
      n = noises[x * 0.001, y * 0.001]
      n = contrast.call(n)
      if tile_at(x, y) == @concrete && n > 0.5
        Tree.new(@object_pool, x, y, n * 2 - 1)
        trees += 1
      end
    end
  end

  def generate_boxes
    boxes = 0
    target_boxes = rand(10..30)
    while boxes < target_boxes do
      x = rand(0..MAP_WIDTH * TILE_WIDTH + OFFSET_X)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT)
      if tile_at(x, y) == @concrete
        Box.new(@object_pool, x, y)
        boxes += 1
      end
    end
  end

  def generate_powerups
    pups = 0
    target_pups = rand(20..30)
    while pups < target_pups do
      x = rand(0..MAP_WIDTH * TILE_WIDTH + OFFSET_X)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT)
      if tile_at(x, y) == @concrete && @object_pool.nearby_point(x, y, 150).empty?
        random_powerup.new(@object_pool, x, y)
        pups += 1
      end
    end
  end

  def random_powerup
    [
     HealthPowerup,
     RepairPowerup,
     FireRatePowerup,
     CharacterSpeedPowerup,
     MagazinePowerup,
    ].sample
  end

  private

  def find_spawn_point
    while true
      x = rand(0..MAP_WIDTH * TILE_WIDTH + OFFSET_X)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT / 2)
      if can_move_to?(x, y) && @object_pool.nearby_point(x, y, 150).empty?
        return [x, y]
      end
    end
  end

  def tile_at(x, y)
    t_x, t_y = Utils.tile_coords(x, y)
    row = @map[:floor][t_x]
    row ? row[t_y] : @water
  end

  def generate_random_map
    noises = Perlin::Noise.new(2)
    contrast = Perlin::Curve.contrast(
      Perlin::Curve::CUBIC, 2)
    map = {}
    MAP_WIDTH.times do |x|
      map[x] = {}
      MAP_HEIGHT.times do |y|
        n = noises[x * 0.1, y * 0.1]
        n = contrast.call(n)
        map[x][y] = choose_tile(n)
      end
    end
    map
  end

  def generate_fix_map(select_map)
    map = {}
    map[:floor] = {}
    maps[select_map][:floor].each_with_index do |x, i_x|
      map[:floor][i_x] = {}
      x.each_with_index do |y, i_y|
        symb = eval "@#{y}"
        map[:floor][i_x][i_y] = symb
      end
    end

    map[:wall_ns] = {}
    maps[select_map][:wall_ns].each_with_index do |x, i_x|
      map[:wall_ns][i_x] = {}
      x.each_with_index do |y, i_y|
        symb = eval "@#{y}"
        map[:wall_ns][i_x][i_y] = symb
      end
    end

    map[:wall_we] = {}
    maps[select_map][:wall_we].each_with_index do |x, i_x|
      map[:wall_we][i_x] = {}
      x.each_with_index do |y, i_y|
        symb = eval "@#{y}"
        map[:wall_we][i_x][i_y] = symb
      end
    end

    map[:ceiling] = {}
    maps[select_map][:ceiling].each_with_index do |x, i_x|
      map[:ceiling][i_x] = {}
      x.each_with_index do |y, i_y|
        symb = eval "@#{y}"
        map[:ceiling][i_x][i_y] = symb
      end
    end

    map
  end

  def choose_tile(val)
    case val
    when 0.0..0.2
      @water
    when 0.3..0.45
      @sand
    else
      @concrete
    end
  end

  def load_tiles
    @sand = images.frame("dirt.png")
    @concrete = images.frame("concrete.png")
    @water = images.frame("gray.png")
    @black = images.frame("black.png")
  end

  def load_walls
    @wall_ns = Gosu::Image.new(Utils.media_path('wall_ns.png'), options={tileable: true })
    @wall_we = Gosu::Image.new(Utils.media_path('wall_we.png'), options={tileable: true })
  end

  def maps
    @@maps ||= Utils.parse_json('maps_parameter.json')
  end

  def images
    @@images ||= Gosu::TexturePacker.load_json(
      Utils.media_path("tiles_packed.json"), :precise)
  end
end
