class Announce
  attr_reader :done

  def initialize(character, ai)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self, character, ai)
  end

  def draw
    @graphics.draw
  end

  def update
    done?
    if Utils.button_down?(Gosu::KbReturn)
        # leave
        $window.close
    end
  end

  def start
    # start!!
  end

  def win
    @win = @ai.all? do |ai|
      ai.health.dead?
    end
  end

  def lose
    @lose = @character.health.dead?
  end

  def done?
    if @win || @lose
      @done = true
    end
  end

end
