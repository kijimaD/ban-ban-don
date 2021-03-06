class Camera
  attr_accessor :x, :y, :zoom
  attr_reader :target

  def target=(target)
    @target = target
    @x, @y = target.x, target.y
    @zoom = 1.0
  end

  def can_view?(x, y, obj)
    x0, x1, y0, y1 = viewport
    (x0 - obj.width..x1).include?(x) &&
      (y0 - obj.height..y1).include?(y)
  end

  def mouse_coords
    x, y = target_delta_on_screen
    mouse_x_on_map = @target.x +
      (x + $window.mouse_x - ($window.width / 2)) / @zoom
    mouse_y_on_map = @target.y +
      (y + $window.mouse_y - ($window.height / 2)) / @zoom
    [mouse_x_on_map, mouse_y_on_map].map(&:round)
  end

  def update
    des_x, des_y = desired_spot
    shift = Utils.adjust_speed(100)
    if @x < des_x
      if des_x - @x < shift
        @x = des_x
      else
        @x += shift
      end
    elsif @x > des_x
      if @x - des_x < shift
        @x = des_x
      else
        @x -= shift
      end
    end
    if @y < des_y
      if des_y - @y < shift
        @y = des_y
      else
        @y += shift
      end
    elsif @y > des_y
      if @y - des_y < shift
        @y = des_y
      else
        @y -= shift
      end
    end
  end

  def to_s
    "FPS: #{Gosu.fps}. " <<
      "#{@x}:#{@y} @ #{'%.2f' % @zoom}. " <<
      'WASD to move, arrows to zoom.'
  end

  def target_delta_on_screen
    [(@x - @target.x) * @zoom, (@y - @target.y) * @zoom]
  end

  def draw_crosshair
    factor = 0.5
    x = $window.mouse_x
    y = $window.mouse_y
    c = crosshair
    c.draw(x - c.width * factor / 2,
           y - c.height * factor / 2,
           1000, factor, factor)
  end

  def viewport
    x0 = @x - ($window.width * 4)  / @zoom
    x1 = @x + ($window.width * 4)  / @zoom
    y0 = @y - ($window.height * 4) / @zoom
    y1 = @y + ($window.height * 4) / @zoom
    [x0, x1, y0, y1]
  end

  def desired_spot
    if @target.recently_shoot?
      Utils.point_at_distance(
        @target.x, @target.y,
        @target.gun_angle,
        200)
    else
      [@target.x, @target.y]
    end
  end

  private
  def crosshair
    @crosshair ||= Gosu::Image.new(Utils.media_path('c_dot.png'))
  end

end
