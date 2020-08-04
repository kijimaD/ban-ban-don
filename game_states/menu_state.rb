# coding: utf-8
class MenuState < GameState
  include Singleton
  attr_accessor :play_state, :choice_return
  TITLE_FONT_COLOR = Gosu::Color.new(174, 0, 0)
  BODY_FONT_COLOR = Gosu::Color::WHITE
  PADDING = 10
  Z = 10

  def initialize
    scores
    @choice_return = {}
    @highscores = []
    @cursor_y = 0
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
  end

  def draw
    bg.draw(0, 0, 0)
    title.draw(
      PADDING,
      PADDING + title.height,
      Z, 1.0, 1.0, TITLE_FONT_COLOR)
    title_menus.each_with_index do |msg, i|
      if i == @cursor_y
        cursor.draw(
        PADDING,
        PADDING + title.height * 2 + cursor.height * i - cursor.height / 4,
        Z)
      end
      info(msg).draw(
        PADDING + cursor.width,
        PADDING + title.height * 2 + cursor.height * i,
        Z, 1.0, 1.0, BODY_FONT_COLOR)
    end
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
    if id == Gosu::KbI && $debug
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbReturn
      ok_sound.play
      if @cursor_y == 0
        @choice_return["on"] = "t"
        choice_branch
      elsif @cursor_y == 1
        @play_state = DemoState.new
        GameState.switch(@play_state)
      elsif @cursor_y == 2
        $window.close
      end
    end
    if id == Gosu::KbDown && can_move_down?
      @cursor_y += 1
      move_sound.play
    end
    if id == Gosu::KbUp && can_move_up?
      @cursor_y -= 1
      move_sound.play
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

  # TODO: Duplicates from choice_state.----
  def can_move_down?
    @cursor_y < title_menus.length - 1
  end

  def can_move_up?
    @cursor_y > 0
  end

  def move_sound
    @@move_sound ||= Gosu::Sample.new(Utils.media_path_sound('cursor_move.wav'))
  end

  def ok_sound
    @@ok_sound ||= Gosu::Sample.new(Utils.media_path_sound('cursor_ok.wav'))
  end
  # ------------------------

  def title
    @title ||= Gosu::Image.from_text("ばんばんどーん!", 80, options = {font: Utils.title_font})
  end

  def info(msg)
    @info = Gosu::Image.from_text(msg, 26, options = {font: Utils.main_font})
  end

  def title_menus
    ["New Game", "Demo Mode", "Quit"]
  end

  # TODO: move
  def images
    @images ||= Gosu::TexturePacker.load_json(
      Utils.media_path("menus_packed.json"))
  end

  def cursor
    @cursor ||= Gosu::Image.new(Utils.media_path('arrow.png'))
  end

end
