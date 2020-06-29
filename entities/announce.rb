class Announce

  def initialize(character, ai)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self, character, ai)
  end

  def draw
    @graphics.draw
  end

  def start
    # start!!
  end

  def win
    @ai.all? do |ai|
      ai.health.dead?
    end
  end

  def lose
    @character.health.dead?
  end

end
