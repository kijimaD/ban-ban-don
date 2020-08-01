class Announce
  attr_reader :done, :win, :lose, :started

  def initialize(character, ai, settings)
    @character = character
    @ai = ai
    @graphics = AnnounceGraphics.new(self)
    @record = ScoreRecord.new(@character, settings)
    start
  end

  def update
    if @ai && !$debug # If demo_state or debug-mode, invalidate annouce function
      win?
      lose?
      once
    end
    if @done && Utils.button_down?(Gosu::KbReturn)
      @record.record
      MenuState.instance.play_state = nil
      MenuState.instance.choice_return = {}
      GameState.switch(MenuState.instance)
    end
  end

  def draw
      @graphics.draw
  end

  def start
      Thread.new do
        @started = true
        sleep 1.4
        @started = nil
      end
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
        sleep 0.4
        fin_sound
      end
    end
  end

  def fin_sound
    if @win
      AnnounceSounds.win
    end
    if @lose
      AnnounceSounds.lose
    end
  end

end
