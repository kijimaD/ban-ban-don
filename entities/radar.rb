class Radar
  UPDATE_FREQUENCY = 1000
  WIDTH = 150
  HEIGHT = 100
  PADDING = 50

  attr_accessor :target

  def initialize(object_pool, target)
    @object_pool = object_pool
    @target = target
    @last_update = 0
  end

  def update
    if Gosu.milliseconds - @last_update > UPDATE_FREQUENCY
      @nearby = nil
    end
    @nearby ||= @object_pool.nearby(@target, 2000).select do |o|
      o.class == Character && !o.health.dead?
    end
  end

  def draw
    draw_character(@target, Gosu::Color::GREEN)
    @nearby && @nearby.each do |t|
      draw_character(t, Gosu::Color::RED)
    end
  end

  private

  def draw_character(character, color)
    if character == @target
      return
    end

    atan = Math.atan2(@target.x - character.x,
                      @target.y - character.y)
    if atan < 0
      atan = atan + 2 * Math::PI
    end
    angle = -atan * 180 / Math::PI

    center_x, center_y = center_coords
    goal_x, goal_y = Utils.point_at_distance(center_x, center_y, angle, $window.height / 2)
    image('sozai_cman_jp_arrow.png').draw_rot(goal_x, goal_y, 1, angle)
  end

  def center_coords
    center_x = $window.width / 2
    center_y = $window.height / 2
    [center_x, center_y]
  end

  def image(image)
    @@image = Gosu::Image.new(
      $window, Utils.media_path(image), false)
  end

end
