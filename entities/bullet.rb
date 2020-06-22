class Bullet < GameObject
  attr_accessor :target_x, :target_y, :speed, :fired_at, :source,
                :weapon, :gun_angle, :sounds

  def initialize(object_pool, object, source_x, source_y, target_x, target_y)
    super(object_pool, source_x, source_y)
    @target_x, @target_y = target_x, target_y
    @gun_angle = object.gun_angle
    @weapon = object.weapon
    @sounds = BulletSounds.new
    BulletPhysics.new(self, object_pool)
    BulletGraphics.new(self)
    @sounds.play(self, object_pool.camera, @weapon['fire_sound'])
  end

  def box
    [@x, @y]
  end

  def explode
    if @weapon['explodable'].to_i == 1
      Explosion.new(object_pool, @x, @y, @source)
    end
    mark_for_removal
  end

  def fire(source, speed)
    @source = source
    @speed = speed * @weapon['speed'].to_f
    @fired_at = Gosu.milliseconds
  end

end
