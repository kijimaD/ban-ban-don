class PlayerInput < Component
  attr_reader :stats

  def initialize(camera, object_pool)
    super(nil)
    @camera = camera
    @object_pool = object_pool
    @stats = Stats.new
  end

  def control(obj)
    self.object = obj
  end

  def on_collision(with)
  end

  def update
    return if object.health.dead?
    d_x, d_y = @camera.target_delta_on_screen
    atan = Math.atan2(($window.width / 2) - d_x - $window.mouse_x,
                      ($window.height / 2) - d_y - $window.mouse_y)
    object.gun_angle = -atan * 180 / Math::PI
    motion_buttons = [Gosu::KbW, Gosu::KbS, Gosu::KbA, Gosu::KbD]

    if any_button_down?(*motion_buttons)
      object.throttle_down = true
      object.physics.change_direction(
        change_angle(object.direction, *motion_buttons))
    else
      object.throttle_down = false
    end

    if Utils.button_down?(Gosu::KbLeftShift)
      object.turbo = true
    else
      object.turbo = false
    end

    if Utils.button_up?(Gosu::KbLeftShift)
      object.reset = true
    else
      object.reset = false
    end

    if Utils.button_down?(Gosu::MsLeft)
      object.shoot(*@camera.mouse_coords)
    end

    if Utils.button_down?(Gosu::KbUp) && @camera.zoom < 2.0
      @camera.zoom += 0.1
    end

    if Utils.button_down?(Gosu::KbDown) && @camera.zoom > 0.6
      @camera.zoom -= 0.1
    end

  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if Utils.button_down?(b)
    end
    false
  end

  def change_angle(previous_angle, up, down, right, left)
    if Utils.button_down?(up)
      angle = 0.0
      angle += 45.0 if Utils.button_down?(left)
      angle -= 45.0 if Utils.button_down?(right)
    elsif Utils.button_down?(down)
      angle = 180.0
      angle -= 45.0 if Utils.button_down?(left)
      angle += 45.0 if Utils.button_down?(right)
    elsif Utils.button_down?(left)
      angle = 90.0
      angle += 45.0 if Utils.button_down?(up)
      angle -= 45.0 if Utils.button_down?(down)
    elsif Utils.button_down?(right)
      angle = 270.0
      angle -= 45.0 if Utils.button_down?(up)
      angle += 45.0 if Utils.button_down?(down)
    end
    angle = (angle + 360) % 360 if angle && angle < 0
    (angle || previous_angle)
  end

end
