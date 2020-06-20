class Character < GameObject
  attr_accessor :throttle_down, :turbo, :reset,
                :direction, :gun_angle, :input,
                :sounds, :physics, :graphics,
                :number_ammo, :health, :weapon,
                :fire_rate_modifier, :speed_modifier

  def initialize(object_pool, input)
    x, y = object_pool.map.spawn_point
    super(object_pool, x, y)
    @input = input
    @input.control(self)
    @physics = CharacterPhysics.new(self, object_pool)
    @sounds = CharacterSounds.new(self, object_pool)
    @health = CharacterHealth.new(self, object_pool)
    @graphics = CharacterGraphics.new(self)
    @weapon_id = rand(0..2).to_s
    @weapon = Utils.load_json("weapon.json")[@weapon_id]
    @shoot_delay = @weapon['shoot_delay'].to_i
    @direction = rand(0..7) * 45
    @gun_angle = rand(0..360)
    @number_ammo = 40
    reset_modifiers
  end

  def box
    @physics.box
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - (@last_shot || 0) > @shoot_delay
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
