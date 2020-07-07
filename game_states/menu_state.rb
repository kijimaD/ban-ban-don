# coding: utf-8
class MenuState < GameState
  include Singleton
  attr_accessor :play_state, :choice_return
  TITLE_FONT_COLOR = Gosu::Color.new(174, 0, 0)
  BODY_FONT_COLOR = Gosu::Color::WHITE
  PADDING = 10

  def initialize
    @message = Gosu::Image.from_text("ばんばんどーん!", 80, options = {font: Utils.title_font})
    @choice_return = []
  end

  def enter
    music.play(true)
    music.volume = 1
  end

  def leave
    music.volume = 0
    music.stop
  end

  def music
    @@music ||= Gosu::Song.new(Utils.media_path_sound('menu_music.wav'))
  end

  def update
    continue_text = @play_state ? "[C]= Continue, " : ""
    @info = Gosu::Image.from_text("[Q]= Quit, #{continue_text}[N]= New Game, [D]= Demo\n[WASD]= Move, [LClick]= Attack", 26, options = {font: Utils.main_font})
  end

  def draw
    bg.draw(0, 0, 1)
    @message.draw(
      PADDING,
      PADDING + @message.height,
      10, 1.0, 1.0, TITLE_FONT_COLOR)
    @info.draw(
      PADDING,
      PADDING + @message.height + @info.height * 2,
      10, 1.0, 1.0, BODY_FONT_COLOR)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbN
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbD
      @play_state = DemoState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbI
      if @choice_return.length == 0
        messages = ["かんたん", "ふつう", "難しい", "パワフル"]
        choice = ChoiceState.new(messages, "images")
        choice.menu_state = self
        GameState.switch(choice)
      elsif @choice_return.length == 1
        messages = ["パワポケ", "白瀬", "石中", "灰原"]
        choice = ChoiceState.new(messages, "images")
        choice.menu_state = self
        GameState.switch(choice)
      else
        @play_state = PlayState.new(@choice_return[0])
        # @play_state.character.select_character = @choice_return[1]
        GameState.switch(@play_state)
      end
    end
  end

  def bg
    @bg ||= Gosu::Image.new(Utils.media_path('city.png'))
  end
end
