# coding: utf-8
class MenuState < GameState
  include Singleton
  attr_accessor :play_state, :choice_return
  TITLE_FONT_COLOR = Gosu::Color.new(174, 0, 0)
  BODY_FONT_COLOR = Gosu::Color::WHITE
  PADDING = 10
  Z = 10

  def initialize
    title
    scores
    @choice_return = {}
    @highscores = []
  end

  def enter
    music.play(true)
    music.volume = 1
    highscores
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
    @title.draw(
      PADDING,
      PADDING + @title.height,
      Z, 1.0, 1.0, TITLE_FONT_COLOR)
    @info.draw(
      PADDING,
      PADDING + @title.height + @info.height * 2,
      Z, 1.0, 1.0, BODY_FONT_COLOR)
    @highscores.each_with_index do |high, i|
      text0 = "#{high[0]}:".ljust(10)
      text1 = "#{high[1]}".ljust(8)
      text2 = "#{high[2]}".ljust(8)
      text = text0 + text1 + text2
      msg = Gosu::Image.from_text(text, 26, options = {font: Utils.main_font})
      msg.draw($window.width - msg.width - PADDING, $window.height - 4 * msg.height + i * msg.height - PADDING, Z)
    end
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
    if id == Gosu::KbI && $debug
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
      messages = [["easy", "easy"], ["normal", "normal"], ["hard", "hard"], ["powerful", "powerful"]]
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

  def scores
    CSV.foreach(Utils.media_path("score.csv"))
  end

  def highscores
    @highscores = []
    difficulties = ["easy", "normal", "hard", "powerful"]
    difficulties.each do |difficulty|
      i = []
      CSV.foreach(Utils.media_path("score.csv")) do |f|
        if f.include?(difficulty)
          i << f
        end
      end
      sorted = i.sort{|a,b|
        b[1].to_i<=>a[1].to_i
      }
      @highscores << sorted[0]
    end
  end

  private

  def title
    @title = Gosu::Image.from_text("ばんばんどーん!", 80, options = {font: Utils.title_font})
  end

  def images
    @images ||= Gosu::TexturePacker.load_json(
      Utils.media_path("menus_packed.json"))
  end

end
