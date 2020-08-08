class CharacterPhysics < Component
  attr_accessor :speed, :in_collision, :collides_with
  COLLIDE_DAMAGE_TIME = 1000
  DASH_TIME = 150

  def initialize(object, object_pool)
    super(object)
    @object = object
    @object_pool = object_pool
    @map = object_pool.map
    @speed, @shift = 0.0
  end

  def can_move_to?(x, y)
    old_x, old_y = object.x, object.y
    object.move(x, y)
    for tx in -15..15 do
      for ty in -15..15 do
        return false unless @map.can_move_to?(x + tx, y + ty)
      end
    end
    @object_pool.nearby(object, 100).each do |obj|
      next if obj.class == Bullet && obj.source == object
      if Utils.collides_with_poly?(obj.box, *object.box)
        if obj.is_a? Powerup
          obj.on_collision(object)
        elsif obj.is_a? Character
          do_hit(obj)
          @collides_with = obj
        else
          @collides_with = obj
        end
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

  def do_hit(obj)
    if @object.character_parameter['collide_damage']
      if obj && not_recently_collide_damage?
        obj.health.inflict_damage(rand(20..40), object)
        @last_hit = Gosu.milliseconds
      end
    end
  end

  def moving?
    @speed > 0
  end

  def not_recently_collide_damage?
    Gosu.milliseconds - (@last_hit || 0) > COLLIDE_DAMAGE_TIME
  end

  def update
    # if object.number_ammo == 0 && object.number_magazine > 0
    if object.number_ammo == 0
      object.reload
    end

    if object.throttle_down && !object.health.dead?
      accelerate
    else
      decelerate
    end

    if Gosu.milliseconds - (@object.last_dash || 0) > DASH_TIME && @object.dashing
      @object.dashing = false
      @speed = 10
    end
    if @object.dashing
      @speed = 100
    end

    if @speed > 0
      new_x, new_y = x, y
      speed = apply_movement_penalty(@speed)
      shift = Utils.adjust_speed(speed) * object.speed_modifier
      case @object.direction.to_i
      when 0
        new_y -= shift
      when 45
        new_x += shift
        new_y -= shift
      when 90
        new_x += shift
      when 135
        new_x += shift
        new_y += shift
      when 180
        new_y += shift
      when 225
        new_y += shift
        new_x -= shift
      when 270
        new_x -= shift
      when 315
        new_x -= shift
        new_y -= shift
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
    w = object.graphics.width / 2
    h = object.graphics.height / 2
    [x - w, y - h - h,
     x + w, y - h - h,
     x + w, y + h - h,
     x - w, y + h - h,
    ]
  end

  def change_direction(new_direction)
    change = (new_direction - object.direction + 360) % 360
    change = 360 - change if change > 180
    object.direction = new_direction % 360
  end

  private

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

end
