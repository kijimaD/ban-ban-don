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
    x1, x2, y1, y2 = radar_coords
    draw_character(@target, Gosu::Color::GREEN)
    @nearby && @nearby.each do |t|
      draw_character(t, Gosu::Color::RED)
    end
  end

  private

  def draw_character(character, color)
    x1, x2, y1, y2 = radar_coords
    tx = x1 + WIDTH / 2 + (character.x - @target.x) / 20
    ty = y1 + HEIGHT / 2 + (character.y - @target.y) / 20

    if (x1..x2).include?(tx) && (y1..y2).include?(ty)
      $window.draw_quad(
        tx - 2, ty - 2, color,
        tx + 2, ty - 2, color,
        tx + 2, ty + 2, color,
        tx - 2, ty + 2, color,
        300)
    end

    if color == Gosu::Color::GREEN
      return
    end

    atan = Math.atan2(character.x - @target.x,
                      character.y - @target.y)
    if atan < 0
      atan = atan + 2 * Math::PI
    end

    angle = -atan * 180 / Math::PI
    goal_x, goal_y = Utils.point_at_distance(tx, ty, angle, 100)
    $window.draw_line(tx, ty, Gosu::Color::WHITE,
                      goal_x, goal_y, color,
                      1000)
  end

  def radar_coords
    x1 = PADDING
    x2 = $window.width
    y1 = PADDING
    y2 = $window.height
    [x1, x2, y1, y2]
  end
end
