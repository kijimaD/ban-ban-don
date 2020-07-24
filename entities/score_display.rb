class ScoreDisplay
  WIDTH = 20
  HEIGHT = 20
  PADDING = 10
  FONT_SIZE = 20
  FONT_COLOR = Gosu::Color::BLACK
  BACKGROUND_COLOR = Gosu::Color.new(255 * 0.66, 255, 255, 255)

  def initialize(args)
    @hud = args[:hud]
    @object_pool = args[:object_pool]
    @character = args[:character]
    @last_update = 0
  end

  def update
  end

  def draw
    x1, y1 = coords
    score_image.draw(x1, y1, HUD::Z, 1.0, 1.0, FONT_COLOR)
    draw_bg
    if $debug
      # damage_image.draw(x1, y1 + HEIGHT, 100)
    end
  end

  def draw_bg
    x1, y1 = coords
    $window.draw_rect(0, 0, 2 * x1 + @score_image.width, 2 * y1 + @score_image.height, BACKGROUND_COLOR, HUD::Z - 1)
  end

  private

  def score_image
    @score_image = Gosu::Image.from_text("score: #{@character.input.stats.score}", FONT_SIZE, options = { font: Utils.title_font })
  end

  def damage_image
    @damage_image = Gosu::Image.from_text("damage: #{@character.input.stats.damage}", FONT_SIZE, options = { font: Utils.title_font })
  end

  def coords
    x1 = PADDING
    y1 = PADDING
    [x1, y1]
  end

end
