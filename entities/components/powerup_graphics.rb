class PowerupGraphics < Component
  AMPLITUDE = 3
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
    image.draw(x - image.width / 2, y - image.height + Math.cos(y_offset) * AMPLITUDE - 8, depth + 1)
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

  def box
    w = image.width / 2
    h = image.height
    [x - w, y - h,
     x + w, y - h,
     x + w, y,
     x - w, y]
  end

  private

  def image
    @image ||= images.frame("#{@type}.png")
  end

  def images
    @@images ||= Gosu::TexturePacker.load_json(Utils.media_path('pickups_packed.json'))
  end

end
