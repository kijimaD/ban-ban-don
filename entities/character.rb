class Character < GameObject
  attr_accessor :throttle_down, :turbo, :reset,
                :direction, :gun_angle, :input,
                :sounds, :physics, :graphics,
                :number_ammo, :number_magazine, :health, :weapon,
                :fire_rate_modifier, :speed_modifier
  MAX_AMMO = 10

  def initialize(object_pool, input)
    x, y = object_pool.map.spawn_point
    super(object_pool, x, y)
    @input = input
    @input.control(self)
    @physics = CharacterPhysics.new(self, object_pool)
    @sounds = CharacterSounds.new(self, object_pool)
    @health = CharacterHealth.new(self, object_pool)
    @graphics = CharacterGraphics.new(self)
    @weapon = Utils.load_json("weapon.json").sample
    @shoot_delay = @weapon['shoot_delay'].to_i
    @direction = rand(0..7) * 45
    @gun_angle = rand(0..360)
    @number_magazine = 10
    @number_ammo = MAX_AMMO
    reset_modifiers
  end

  def box
    @physics.box
  end

  def shoot(target_x, target_y)
    if can_shoot?
      if @number_ammo > 0
        @last_shot = Gosu.milliseconds
        Bullet.new(object_pool, self, @x, @y, target_x, target_y).fire(self, 1000)
        @number_ammo -= 1
        if $debug
          @number_ammo += 1
        end
      end
    end
  end

  def can_shoot?
    Gosu.milliseconds - (@last_shot || 0) > (@shoot_delay / @fire_rate_modifier)
  end

  def reload
    if @number_magazine > 0 && Gosu.milliseconds - (@last_reload || 0) > 3000
      Thread.new do
        @last_reload = Gosu.milliseconds
        @on_reload = true
        sleep 0.8
        @sounds.reload
        @number_magazine -= 1
        sleep 2
        @number_ammo = MAX_AMMO
        @on_reload = false
      end
    end
  end

  def on_collision(object)
    return unless object
    if object.class == Character
      object.input.on_collision(object)
    else
      object.on_collision(self)
    end
    if object.class != Bullet
      @sounds.collide if @physics.speed > 1
    end
  end

  def reset_modifiers
    @fire_rate_modifier = 1
    @speed_modifier = 1
  end
end
