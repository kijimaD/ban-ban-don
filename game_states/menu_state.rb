# coding: utf-8
class MenuState < GameState
  include Singleton
  attr_accessor :play_state, :choice_return
  TITLE_FONT_COLOR = Gosu::Color.new(174, 0, 0)
  BODY_FONT_COLOR = Gosu::Color::WHITE
  PADDING = 10
  Z = 10

  def initialize
    @message = Gosu::Image.from_text("ばんばんどーん!", 80, options = {font: Utils.title_font})
    @choice_return = {}
  end

  def enter
    music.play(true)
    music.volume = 1
    choice_branch
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
    bg.draw(0, 0, 0)
    @message.draw(
      PADDING,
      PADDING + @message.height,
      Z, 1.0, 1.0, TITLE_FONT_COLOR)
    @info.draw(
      PADDING,
      PADDING + @message.height + @info.height * 2,
      Z, 1.0, 1.0, BODY_FONT_COLOR)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbN
      @choice_return["on"] = "t"
      choice_branch
    end
    if id == Gosu::KbD
      @play_state = DemoState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbI
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
  end

  def bg
    @bg ||= Gosu::Image.new(Utils.media_path('city.png'))
  end

  def choice_branch
    if @choice_return.has_key?("on") == false
      return
    elsif @choice_return.has_key?("difficulty") == false
      messages = [["easy", 0.8], ["normal", 1], ["hard", 1.2], ["powerful", 1.5]]
      choice = ChoiceState.new(messages, images, "difficulty")
      choice.menu_state = self
      GameState.switch(choice)
    elsif @choice_return.has_key?("chara") == false
      messages = [["pawapoke", "pawapoke"], ["sirase", "sirase"], ["ishinaka", "ishinaka"], ["haibara", "haibara"]]
      choice = ChoiceState.new(messages, images, "chara")
      choice.menu_state = self
      GameState.switch(choice)
    elsif @choice_return["difficulty"] && @choice_return["chara"]
      @play_state = PlayState.new(@choice_return)
      GameState.switch(@play_state)
    end
  end

  private

  def images
    @images ||= Gosu::TexturePacker.load_json(
      Utils.media_path("menus_packed.json"))
  end

end
