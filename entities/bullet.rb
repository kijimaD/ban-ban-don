class Bullet < GameObject
  attr_accessor :x, :y, :target_x, :target_y, :speed, :fired_at, :source,
                :weapon, :gun_angle

  def initialize(object_pool, object, source_x, source_y, target_x, target_y)
    super(object_pool)
    @object = object
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    @gun_angle = object.gun_angle
    @weapon = @object.weapon
    BulletPhysics.new(self, object_pool)
    BulletGraphics.new(self)
    BulletSounds.play(@weapon['fire_sound'])
  end

  def box
    [x, y]
  end

  def explode
    if @weapon['explodable'].to_i == 1
      Explosion.new(object_pool, @x, @y)
    end
    mark_for_removal
  end

  def fire(source, speed)
    @source = source
    @speed = speed * @weapon['speed'].to_f
    @fired_at = Gosu.milliseconds
  end

end
