class BulletPhysics < Component
  START_DIST = 20
  MAX_DIST = 500

  def initialize(game_object, object_pool)
    super(game_object)
    @x, @y = point_at_distance(START_DIST)
    object.move(@x, @y)
    @game_object = game_object
    @object_pool = object_pool
    if trajectory_length > MAX_DIST
      object.target_x, object.target_y = point_at_distance(MAX_DIST)
    end
  end

  def update
    fly_speed = Utils.adjust_speed(object.speed)
    now = Gosu.milliseconds
    @last_update ||= object.fired_at
    fly_distance = (now - @last_update) * 0.001 * fly_speed
    @x, @y = *point_at_distance(fly_distance)
    object.move(@x, @y)
    @last_update = now
    check_hit
    object.explode if arrived?
  end

  def trajectory_length
    Utils.distance_between(object.target_x, object.target_y, x, y)
  end

  def point_at_distance(distance)
    if distance > trajectory_length
      return [object.target_x, object.target_y]
    end
    distance_factor = distance.to_f / trajectory_length
    p_x = x + (object.target_x - x) * distance_factor
    p_y = y + (object.target_y - y) * distance_factor
    [p_x, p_y]
  end

  def box
    w = object.graphics.width / 2
    h = object.graphics.height / 2
    Utils.rotate(object.gun_angle, @x, @y,
                 @x - w, @y - h,
                 @x + w, @y - h,
                 @x + w, @y + h,
                 @x - w, @y + h,
                )
  end

  private

  def arrived?
    x == object.target_x && y == object.target_y
  end

  def check_hit
    @object_pool.nearby(object, 100).each do |obj|
      next if obj == object.source # Don't hit source object
      if obj.class == Tree
        if Utils.distance_between(x, y, obj.x, obj.y) < @game_object.graphics.width.to_i
          return do_hit(obj) if obj.respond_to?(:health)
        end
      elsif Utils.collides_with_poly?(obj.box, *object.box)
        # Direct hit - extra damage
        return do_hit(obj) if obj.respond_to?(:health)
      end
    end
    unless @object_pool.map.can_through_bullet?(x, y)
      return do_hit
    end
    object.prev_x = x
    object.prev_y = y
  end

  def do_hit(obj = nil)
    @game_object.sounds.hit(@game_object, @object_pool.camera)
    if obj
      damage = @game_object.weapon['damage'].to_i
      obj.health.inflict_damage(rand(damage - 10 .. damage + 10), object.source)
    end
    object.explode
    object.target_x = x
    object.target_y = y
  end

end
