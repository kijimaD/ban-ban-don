class Character < GameObject
  SHOOT_DELAY = 500
  attr_accessor :x, :y, :throttle_down, :direction, :gun_angle,
                :sounds, :physics, :number_ammo

  def initialize(object_pool, input)
    super(object_pool)
    @input = input
    @input.control(self)
    @physics = CharacterPhysics.new(self, object_pool)
    @graphics = CharacterGraphics.new(self)
    @sounds = CharacterSounds.new(self)
    @direction = @gun_angle = 0.0
    @number_ammo = 10
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - (@last_shot || 0) > SHOOT_DELAY
      if @number_ammo > 0
        @last_shot = Gosu.milliseconds
        Bullet.new(object_pool, @x, @y, target_x, target_y).fire(100)
        @number_ammo -= 1
      end
    end
  end

end
