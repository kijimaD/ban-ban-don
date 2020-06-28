class Radar
  UPDATE_FREQUENCY = 1000
  Z = 200
  WIDTH = 150
  HEIGHT = 100
  PADDING = 50
  MIN_DISTANCE = 300
  MAX_DISTANCE = 2000
  attr_accessor :object

  def initialize(object_pool, object)
    @object_pool = object_pool
    @object = object
    @last_update = 0
  end

  def update
    if Gosu.milliseconds - @last_update > UPDATE_FREQUENCY
      @nearby = nil
    end
    @nearby ||= @object_pool.nearby(@object, MAX_DISTANCE, MIN_DISTANCE).select do |o|
      o.class == Character && !o.health.dead?
    end
  end

  def draw
    draw_character(@object)
    @nearby && @nearby.each do |t|
      draw_character(t)
    end
  end

  private

  def draw_character(character)
    if character == @object
      return
    end

    atan = Math.atan2(@object.x - character.x,
                      @object.y - character.y)
    if atan < 0
      atan = atan + 2 * Math::PI
    end
    angle = -atan * 180 / Math::PI

    center_x, center_y = center_coords
    goal_x, goal_y = Utils.point_at_distance(center_x, center_y, angle, $window.height / 2)
    image('sozai_cman_jp_arrow.png').draw_rot(goal_x, goal_y, Z, angle)
  end

  def center_coords
    center_x = $window.width / 2
    center_y = $window.height / 2
    [center_x, center_y]
  end

  def image(image)
    @@image ||= Gosu::Image.new(Utils.media_path(image))
  end

end
