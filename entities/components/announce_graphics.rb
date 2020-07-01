class AnnounceGraphics

  def initialize(object)
    @object = object
  end

  def draw
    if @object.win
      win_or_lose("win!!")
    end
    if @object.lose
      win_or_lose("lose!!")
    end
  end

  def win_or_lose(wl)
    x, y = coords
    Gosu::Image.from_text(wl, 120, options = {font: Utils.title_font}).draw(x, y, 300, 1, 1, Gosu::Color::RED)
  end

  def coords
    x = $window.width / 2
    y = $window.height / 2
    x = 100
    y = 100
    [x, y]
  end
end
