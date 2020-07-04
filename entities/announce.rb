class Announce
  attr_reader :done, :win, :lose

  def initialize(character, ai)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self)
  end

  def draw
    if @start
      @graphics.draw
    end
  end

  def update
    win?
    lose?
    once
    if @done && Utils.button_down?(Gosu::KbReturn)
      MenuState.instance.play_state = nil
      GameState.switch(MenuState.instance)
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

  def once
    if (@win || @lose) && @done.nil?
      @done = true
      Thread.new do
        sleep 2
        @start = true
        sound
      end
    end
  end

  def sound
    if @win
      AnnounceSounds.win
    end
    if @lose
      AnnounceSounds.lose
    end
  end

end
