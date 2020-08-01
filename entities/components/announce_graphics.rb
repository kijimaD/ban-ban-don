class AnnounceGraphics
  DONE_ANIMATION_SPEED = 8
  START_ANIMATION_SPEED = 30

  def initialize(object)
    @object = object
    @current_frame = 0
  end

  def draw
    if @object.win
      win_or_lose("win!!")
    end
    if @object.lose
      win_or_lose("lose!!")
    end
    if @object.started
      start
    end
  end

  def update
  end

  def win_or_lose(wl)
    x, y = coords
    if (@y || @y = 0) < y
      wl_image(x, @y, wl)
      @y += DONE_ANIMATION_SPEED
    else
      wl_image(x, y, wl)
    end
  end

  def start
    x, y = coords
    if (@start_y || @start_y = 0) < y
      start_image(x, @start_y)
      @start_y += START_ANIMATION_SPEED
    else
      AnnounceSounds.start # Multiple play
      start_image(x, y)
    end
  end

  def wl_image(x, y, word)
    Gosu::Image.from_text(word, 120, options = {font: Utils.title_font}).draw(x, y, HUD::Z, 1, 1, Gosu::Color::RED)
  end

  def start_image(x, y)
    Gosu::Image.from_text("START!!", 120, options = {font: Utils.title_font}).draw(x, y, HUD::Z, 1, 1, Gosu::Color::RED)
  end

  def coords
    x = $window.width / 2
    y = $window.height / 2
    [x, y]
  end
end
