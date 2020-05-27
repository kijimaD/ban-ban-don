class Character < GameObject
  SHOOT_DELAY = 500
  attr_accessor :x, :y, :throttle_down, :turbo, :reset,
                :direction, :gun_angle,
                :sounds, :physics, :graphics, :number_ammo

  def initialize(object_pool, input)
    super(object_pool)
    @input = input
    @input.control(self)
    @physics = CharacterPhysics.new(self, object_pool)
    @graphics = CharacterGraphics.new(self)
    @sounds = CharacterSounds.new(self)
    @direction = rand(0..7) * 45
    @gun_angle = rand(0..360)
    @number_ammo = 10

  end

  def box
    @physics.box
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - (@last_shot || 0) > SHOOT_DELAY
      if @number_ammo > 0
        @last_shot = Gosu.milliseconds
        Bullet.new(object_pool, @x, @y, target_x, target_y).fire(self, 100)
        @number_ammo -= 1
      end
    end
  end

end
