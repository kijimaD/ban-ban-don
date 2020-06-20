class PowerupGraphics < Component
  AMPLITUDE = 2
  DELAY = 300
  FRAME = 4

  def initialize(object, type)
    super(object)
    @y = 0
    @type = type
    @last_update = Gosu.milliseconds
  end

  def draw(viewport)
    y_offset = animation(@y)
    image.draw(x - 12, center_y + Math.cos(y_offset) * AMPLITUDE, 1)
    Utils.mark_corners(object.box) if $debug
  end

  def animation(y)
    now = Gosu.milliseconds
    if now - @last_update > DELAY
      if y > FRAME
        y = 0
      end
      y += 1
      @last_update = now
    end
    @y = y
  end

  private

  def image
    @image ||= images.frame("#{@type}.png")
  end

  def images
    @@images ||= Gosu::TexturePacker.load_json(Utils.media_path('pickups.json'))
  end

  def center_x
    @center_x ||= x - image.width / 2
  end

  def center_y
    @center_y ||= y - image.height / 2
  end

end
