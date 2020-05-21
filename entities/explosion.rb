class Explosion < GameObject
  attr_accessor :x, :y
  FRAME_DELAY  = 10

  def initialize(object_pool, x, y)
    super(object_pool)
    @x, @y = x, y
    ExplosionGraphics.new(self)
    ExplosionSounds.play

    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2 + 3,
      @y - image.height / 2 - 35,
      20)
  end

  def animation
    @@animation ||=
    Gosu::Image.load_tiles(
      $window, Utils.media_path('explosion.png'), 128, 128, false)
  end

  def done?
    @done ||= @current_frame == animation.size
  end

  private

  def current_frame
    animation[@current_frame % animation.size]
  end

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    end
  end

end
