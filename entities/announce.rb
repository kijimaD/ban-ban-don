class Announce
  attr_reader :done, :win, :lose

  def initialize(character, ai)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self)
  end

  def draw
    @graphics.draw
  end

  def update
    win?
    lose?
    done?
    if Utils.button_down?(Gosu::KbReturn)
        # leave
        $window.close
    end
  end

  def start
    # start!!
  end

  def win?
    @win = @ai.all? do |ai|
      ai.health.dead?
    end
  end

  def lose?
    @lose = @character.health.dead?
  end

  def done?
    puts @done.nil?
    if (@win || @lose) && @done.nil?
      @done = true
      if @win
        AnnounceSounds.play
      end
      if @lose
        AnnounceSounds.play
      end
    end
  end

end
