class Character < GameObject
  attr_accessor :throttle_down, :reset,
                :direction, :gun_angle, :input,
                :sounds, :physics, :graphics,
                :number_ammo, :number_magazine, :health,
                :fire_rate_modifier, :speed_modifier,
                :character_parameter,
                :last_dash, :dashing
  RECENTLY_SHOOT_TIME = 2000
  DASH_COOLDOWN_TIME = 1000

  def initialize(object, object_pool, input, character_parameter)
    x, y = object_pool.map.spawn_point
    super(object_pool, x, y)
    @object = object
    @input = input
    @input.control(self)
    @character_parameter = character_parameter
    @direction = rand(0..7) * 45
    @gun_angle = rand(0..360)
    @physics = CharacterPhysics.new(self, object_pool)
    @sounds = CharacterSounds.new(self, object_pool)
    @health = CharacterHealth.new(self, object_pool)
    @graphics = CharacterGraphics.new(self)
    @shoot_delay = weapon['shoot_delay'].to_i
    difficulty_factors = { 'easy' => 0.3, 'normal' => 0.5, 'hard' => 0.7, 'powerful' => 1.0 }
    @difficulty_factor = difficulty_factors[@object.difficulty].to_i
    @number_magazine = 10 * (1 - @difficulty_factor)
    @number_ammo = weapon['number_shots'].to_i
    reset_modifiers
  end

  def box
    @physics.box
  end

  def shoot(target_x, target_y)
    if can_shoot?
      if weapon['name'] == "None"
        @direction = (Utils.angle_between(x, y, target_x, target_y) / 45).floor * 45
        dash
        return
      end
      if @number_ammo > 0
        @last_shoot = Gosu.milliseconds
        Bullet.new(object_pool, self, @x + @graphics.width / 2, @y - @graphics.height / 2, target_x, target_y).fire(self, 1000)
        @number_ammo -= 1
        if $debug
          @number_ammo += 1
        end
      elsif @number_ammo == 0
        @last_shoot = Gosu.milliseconds
        @sounds.out_of_ammo
      end
    end
  end

  def dash
    if can_dash?
      @last_dash = Gosu.milliseconds
      @dashing = true
    end
  end

  def can_dash?
    Gosu.milliseconds - (@last_dash || 0) > DASH_COOLDOWN_TIME
  end

  def can_shoot?
    Gosu.milliseconds - (@last_shoot || 0) > (@shoot_delay / @fire_rate_modifier)
  end

  def recently_shoot?
    Gosu.milliseconds - (@last_shoot || -10000) < RECENTLY_SHOOT_TIME
  end

  def reload
    if @number_magazine > 0 && @on_reload.nil?
      Thread.new do
        @last_reload = Gosu.milliseconds
        @on_reload = true
        @sounds.reload
        sleep 0.8
        @number_magazine -= 1
        sleep weapon['reload_time'].to_i
        @number_ammo = weapon['number_shots'].to_i
        @on_reload = nil
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

  def weapon
    weapon = @character_parameter['weapon']
    @weapon ||= Utils.load_json("weapons_parameter.json")["#{weapon}"]
  end

end
