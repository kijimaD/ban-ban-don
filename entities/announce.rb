class Announce < GameObject

  def initialize(character, ai)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self)
  end

  def draw
    if @character.health.dead?
      lose
    end
    @ai.each do |ai|
      if ai.health.dead?
        win
      end
    end
  end

  def start
    # start!!
  end

  def win
    @graphics.win_or_lose("win!!")
  end

  def lose
    @graphics.win_or_lose("lose!!")
  end

end
