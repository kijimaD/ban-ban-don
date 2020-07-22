class AnnounceGraphics
  ANIMATION_SPEED = 4

  def initialize(object)
    @object = object
    @current_frame = 0
    @y = 0
  end

  def draw
    if @object.win
      win_or_lose("win!!")
    end
    if @object.lose
        win_or_lose("lose!!")
    end
  end

  def update
  end

  def win_or_lose(wl)
    x, y = coords
    if @y < y
      image(x, @y, wl)
      @y += ANIMATION_SPEED
    else
      image(x, y, wl)
    end
  end

  def image(x, y, word)
    Gosu::Image.from_text(word, 120, options = {font: Utils.title_font}).draw(x, y, HUD::Z, 1, 1, Gosu::Color::RED)
  end

  def coords
    x = $window.width / 2
    y = $window.height / 2
    [x, y]
  end
end
