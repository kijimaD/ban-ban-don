class Explosion < GameObject

  def initialize(object_pool, x, y, source)
    super(object_pool, x, y)
    @object_pool = object_pool
    @source = source
    ExplosionGraphics.new(self)
    ExplosionSounds.play(self, object_pool.camera)
    inflict_damage
    if @object_pool.map.can_move_to?(x, y)
      Thread.new do
        sleep rand(1..1.2)
        Damage.new(@object_pool, x, y)
        sleep 0.5
      end
    end
  end

  def effect?
    true
  end

  def mark_for_removal
    super
  end

  private

  def inflict_damage
    object_pool.nearby(self, 100).each do |obj|
      if obj.respond_to?(:health)
        obj.health.inflict_damage(
          Math.sqrt(3 * 100 - Utils.distance_between(
                      obj.x, obj.y, @x, @y)), @source)
      end
    end
  end

end
