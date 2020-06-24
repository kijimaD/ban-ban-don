# coding: utf-8
class MenuState < GameState
  include Singleton
  attr_accessor :play_state
  TITLE_FONT_COLOR = Gosu::Color::WHITE
  BODY_FONT_COLOR = Gosu::Color::GREEN
  PADDING = 10

  def initialize
    @message = Gosu::Image.from_text("ばんばんどーん", 40)
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
    @@music ||= Gosu::Song.new(Utils.media_path_sound('menu_music.mp3'))
  end

  def update
    continue_text = @play_state ? "[C]= Continue, " : ""
    @info = Gosu::Image.from_text("[Q]= Quit, #{continue_text}[N]= New Game, [WASD]= Move, [LClick]= Attack",20)
  end

  def draw
    bg.draw(0, 0, 1)
    @message.draw(
      PADDING,
      PADDING + @message.height,
      10, 1.0, 1.0, TITLE_FONT_COLOR)
    @info.draw(
      PADDING,
      PADDING + @message.height * 3,
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
  end

  def bg
    @bg ||= Gosu::Image.new(Utils.media_path('city.png'))
  end
end
