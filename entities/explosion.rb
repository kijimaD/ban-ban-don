class Explosion < GameObject
  attr_accessor :x, :y

  def initialize(object_pool, x, y)
    super(object_pool)
    @object_pool = object_pool
    @x, @y = x, y
    ExplosionGraphics.new(self)
    ExplosionSounds.play(self, object_pool.camera)
    inflict_damage
    if @object_pool.map.can_move_to?(x, y)
      Damage.new(@object_pool, @x, @y)
    end
  end

  private

  def inflict_damage
    object_pool.nearby(self, 100).each do |obj|
      if obj.respond_to?(:health)
        obj.health.inflict_damage(
          Math.sqrt(3 * 100 - Utils.distance_between(
                      obj.x, obj.y, x, y)))
      end
    end
  end

end
