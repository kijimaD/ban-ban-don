class ChoiceState < GameState
  attr_accessor :menu_state
  PADDING = 10

  def initialize(messages, images)
    @messages = messages
    @images = images
    @message = Gosu::Image.from_text(messages, 80, options = {font: Utils.title_font})
  end

  def enter
  end

  def leave
  end

  def draw
    @menu_state.draw
    @message.draw(PADDING,
                  PADDING + @message.height,
                  10, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbReturn && @menu_state
      GameState.switch(@menu_state)
    end
  end

end
