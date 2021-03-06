class AiInput < Component
  attr_reader :stats
  UPDATE_RATE = 200

  def initialize(play_state, object_pool)
    super(nil)
    @play_state = play_state
    @object_pool = object_pool
    @last_update = Gosu.milliseconds
    @stats = Stats.new
  end

  def control(obj)
    self.object = obj
    object.components << self
    @vision = AiVision.new(obj, @object_pool,
                           rand(700..1200))
    @gun = AiGun.new(obj, @vision)
    @motion = CharacterMotionFSM.new(obj, @vision, @gun)
  end

  def on_collision(with)
    return if object.health.dead?
    @motion.on_collision(with)
  end

  def on_damage(amount)
    @motion.on_damage(amount)
  end

  def update
    return if object.health.dead?
    if @play_state.announce.done || @play_state.announce.started
      object.throttle_down = false
      object.physics.speed = 0
      return
    end
    @gun.adjust_angle
    now = Gosu.milliseconds
    return if now - @last_update < UPDATE_RATE
    @last_update = now
    @vision.update
    @gun.update
    @motion.update
  end

  def draw(viewport)
    @motion.draw(viewport)
    @gun.draw(viewport)
  end
end
