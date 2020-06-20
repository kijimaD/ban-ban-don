class PowerupDisplay
  WIDTH = 30
  HEIGHT = 80
  PADDING = 10

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
  end

  def draw
    x1, x2, y1, y2 = coords
    if fire_rate_image
      fire_rate_image.draw(50, 50, 200)
    end
    if speed_image
      speed_image.draw(50, 60, 200)
    end
  end

  def fire_rate_image
    if @character.fire_rate_modifier > 1
      if @fire_rate != @character.fire_rate_modifier
        @fire_rate = @character.fire_rate_modifier
        @fire_rate_image = Gosu::Image.from_text(
          "Fire rate: #{@fire_rate.round(2)}X", 20)
      end
    else
      @fire_rate_image = nil
    end
    @fire_rate_image
  end

  def speed_image
    if @character.speed_modifier > 1
      if @speed != @character.speed_modifier
        @speed = @character.speed_modifier
        @speed_image = Gosu::Image.from_text(
          "Speed: #{@speed.round(2)}X", 20)
      end
    else
      @speed_image = nil
    end
    @speed_image
  end

  def coords
    x1 = PADDING
    x2 = $window.width - PADDING
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

end
