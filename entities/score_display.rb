class ScoreDisplay
  WIDTH = 20
  HEIGHT = 20
  PADDING = 10
  FONT_SIZE = 20

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @last_update = 0
  end

  def update
  end

  def draw
    x1, y1 = coords
    score_image.draw(x1, y1, 100)
  end

  private

  def score_image
    image = Gosu::Image.from_text("damage: #{@character.input.stats.damage}\nscore: #{@character.input.stats.score}", FONT_SIZE)
  end

  def coords
    x1 = PADDING
    y1 = PADDING + HEIGHT
    [x1, y1]
  end

end
