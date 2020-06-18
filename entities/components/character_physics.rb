class CharacterPhysics < Component
  attr_accessor :speed, :shift, :in_collision, :collides_with

  def initialize(game_object, object_pool)
    super(game_object)
    @object_pool = object_pool
    @map = object_pool.map
    @speed, @shift = 0.0
  end

  def can_move_to?(x, y)
    old_x, old_y = object.x, object.y
    object.move(x, y)
    return false unless @map.can_move_to?(x, y)
    @object_pool.nearby(object, 100).each do |obj|
      next if obj.class == Bullet && obj.source == object
      if collides_with_poly?(obj.box)
        @collides_with = obj
        old_distance = Utils.distance_between(
          obj.x, obj.y, old_x, old_y)
        new_distance = Utils.distance_between(
          obj.x, obj.y, x, y)
        return false if new_distance < old_distance
      else
        @collides_with = nil
      end
    end
    true
  ensure
    object.move(old_x, old_y)
  end

  def moving?
    @speed > 0
  end

  def update
    if object.throttle_down && !object.health.dead?
      accelerate
    else
      decelerate
    end

    if object.turbo
      turbo
    end
    if object.reset
      reset
    end

    if @speed > 0
      new_x, new_y = x, y
      speed = apply_movement_penalty(@speed)
      @shift = Utils.adjust_speed(speed)
      case @object.direction.to_i
      when 0
        new_y -= @shift
      when 45
        new_x += @shift
        new_y -= @shift
      when 90
        new_x += @shift
      when 135
        new_x += @shift
        new_y += @shift
      when 180
        new_y += @shift
      when 225
        new_y += @shift
        new_x -= @shift
      when 270
        new_x -= @shift
      when 315
        new_x -= @shift
        new_y -= @shift
      end
      if can_move_to?(new_x, new_y)
        object.move(new_x, new_y)
        @in_collision = false
      else
        object.on_collision(@collides_with)
        @speed = 0.0
        @in_collision = true
      end
    end
  end

  def box_width
    @box_width ||= object.graphics.width
  end

  def box_height
    @box_height ||= object.graphics.height
  end

  def box
    w = box_width / 2 - 1
    h = box_height / 2 - 1
    tw = 8                      # track width
    fd = 8                      # track depth
    rd = 6                      # rear depth
    Utils.rotate(object.direction, x, y,
                 x + w,      y + h,
                 x + w - tw, y + h,
                 x + w - tw, y + h - fd,

                 x - w + tw, y + h - fd,
                 x - w + tw, y + h,
                 x - w,      y + h,

                 x - w,      y - h,
                 x - w + tw, y - h,
                 x - w + tw, y - h + rd,

                 x + w - tw, y - h + rd,
                 x + w - tw, y - h,
                 x + w,      y - h,
                )
  end

  def change_direction(new_direction)
    change = (new_direction - object.direction + 360) % 360
    change = 360 - change if change > 180
    # if change > 90
    #   @speed = 0
    # elsif change > 45
    #   @speed *= 0.33
    # elsif change > 0
    #   @speed *= 0.66
    # end
    object.direction = new_direction
  end

  private

  def collides_with_poly?(poly)
    if poly
      if poly.size == 2
        px, py = poly
        return Utils.point_in_poly(px, py, *box)
      end
      poly.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *box)
      end
      box.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *poly)
      end
    end
    false
  end

  def collides_with_point?(x, y)
    Utils.point_in_poly(x, y, box)
  end

  def apply_movement_penalty(speed)
    speed * (1.0 - @map.movement_penalty(x,y))
  end

  def accelerate
    @speed += 1.0 if @speed < 10
  end

  def decelerate
    @speed -= 5.0 if @speed > 0
    @speed = 0.0 if @speed < 0
  end

  def turbo
    @speed = 100
  end

  def reset
    @speed = 1
  end

end
