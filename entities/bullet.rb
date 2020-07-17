class Bullet < GameObject
  L = 10
  PQ = 10
  attr_accessor :target_x, :target_y, :speed, :fired_at, :source,
                :weapon, :gun_angle, :sounds,
                :graphics

  def initialize(object_pool, object, source_x, source_y, target_x, target_y)
    super(object_pool, source_x, source_y)
    @object_pool = object_pool
    @target_x = (-L * @x + (PQ + L) * target_x) / PQ
    @target_y = (-L * @y + (PQ + L) * target_y) / PQ
    @gun_angle = object.gun_angle
    @weapon = object.weapon
    @sounds = BulletSounds.new
    @physics = BulletPhysics.new(self, object_pool)
    @graphics = BulletGraphics.new(self)
    @sounds.play(self, object_pool.camera, @weapon['fire_sound'])
  end

  def box
    return @box if @box
    @physics.box
  end

  def explode
    if @weapon['explodable'].to_i == 1
      Thread.new do
        sleep 0.1
        Explosion.new(object_pool, @x, @y, @source)
      end
    end
    mark_for_removal
  end

  def fire(source, speed)
    @source = source
    @speed = speed * @weapon['speed'].to_f
    @fired_at = Gosu.milliseconds
  end

end
