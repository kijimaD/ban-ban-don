class Map
  MAP_WIDTH = 30
  MAP_HEIGHT = 30
  TILE_WIDTH = 256
  TILE_HEIGHT = 128

  def self.bounding_box
    center = [MAP_WIDTH * TILE_WIDTH / 2,
              MAP_HEIGHT * TILE_HEIGHT / 2]
    half_dimension = [MAP_WIDTH * TILE_WIDTH,
                      MAP_HEIGHT * TILE_HEIGHT]
    AxisAlignedBoundingBox.new(center, half_dimension)
  end

  def initialize(object_pool)
    load_tiles
    @object_pool = object_pool
    object_pool.map = self
    @map = generate_map
    generate_trees
    generate_boxes
    generate_powerups
  end

  def draw(viewport)
    viewport[0] = viewport[0] / TILE_WIDTH
    viewport[1] = viewport[1] / TILE_WIDTH
    viewport[2] = viewport[2] / TILE_HEIGHT
    viewport[3] = viewport[3] / TILE_HEIGHT * 2
    x0, x1, y0, y1 = viewport.map(&:to_i)

    @even_x = 0
    (x0-10..x1+10).each do |x|
      @even_x = x * TILE_WIDTH
      @even_y = 0
      (y0-10..y1+10).each do |y|
        row = @map[x]
        if y % 2 == 0
          @even_y = y * TILE_HEIGHT / 2
          map_x = @even_x
          map_y = @even_y
        elsif y % 2 == 1
          map_x = @even_x - TILE_WIDTH / 2
          map_y = @even_y + TILE_HEIGHT / 2
        end

        if row
          tile = @map[x][y]
          if tile
            tile.draw(map_x, map_y, 0)
            @msg = Gosu::Image.from_text("X:#{x}, Y:#{y}", 16).draw(map_x, map_y, 100)
          else
            # @water.draw(map_x, map_y, 0)
          end
        else
          # @water.draw(map_x, map_y, 0)
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
      x = rand(0..MAP_WIDTH * TILE_WIDTH)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT / 2)
      n = noises[x * 0.001, y * 0.001]
      n = contrast.call(n)
      if tile_at(x, y) == @grass && n > 0.5
        Tree.new(@object_pool, x, y, n * 2 - 1)
        trees += 1
      end
    end
  end

  def generate_boxes
    boxes = 0
    target_boxes = rand(10..30)
    while boxes < target_boxes do
      x = rand(0..MAP_WIDTH * TILE_WIDTH)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT / 2)
      if tile_at(x, y) != @water
        Box.new(@object_pool, x, y)
        boxes += 1
      end
    end
  end

  def generate_powerups
    pups = 0
    target_pups = rand(20..30)
    while pups < target_pups do
      x = rand(0..MAP_WIDTH * TILE_WIDTH)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT / 2)
      if tile_at(x, y) != @water && @object_pool.nearby_point(x, y, 150).empty?
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
      x = rand(0..MAP_WIDTH * TILE_WIDTH)
      y = rand(0..MAP_HEIGHT * TILE_HEIGHT / 2)
      if can_move_to?(x, y) && @object_pool.nearby_point(x, y, 150).empty?
        return [x, y]
      end
    end
  end

  def tile_at(x, y)
    # t_x = ((x / TILE_WIDTH) % TILE_WIDTH).floor
    # t_y = ((y / TILE_HEIGHT * 2) % TILE_HEIGHT).floor
    t_x = (y / TILE_HEIGHT / 2 + x / TILE_WIDTH).floor
    t_y = (y / TILE_HEIGHT / 2 - x / TILE_WIDTH).floor
    puts "x:#{t_x}, y:#{t_y}"
    row = @map[t_x]
    row ? row[t_y] : @water
  end

  def load_tiles
    @sand = Gosu::Image.new(Utils.media_path('dirt.png'), options = {tileable: true})
    @grass = Gosu::Image.new(Utils.media_path('concrete.png'), options = {tileable: true})
    @water = Gosu::Image.new(Utils.media_path('snow.png'), options = {tileable: true})
  end

  def generate_map
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

  def choose_tile(val)
    case val
    when 0.0..0.2
      @water
    when 0.3..0.45
      @sand
    else
      @grass
    end
  end
end
