class DamagePopupGraphics < Component
FRAME = 30
  def initialize(object, amount)
    super(object)
    @amount = amount
    @frame = 0
    @offset = 0
  end

  def draw(viewport)
    font_color = Gosu::Color.new(255 / FRAME * (FRAME - @frame) + 30, 255, 255, 255)
    if @frame < FRAME
      if @frame % 2 == 0
        @offset += 0.4
      end
      popup_msg.draw(x, y - @offset * 10, HUD::Z, 1.0, 1.0, font_color)
      @frame += 1
    else
      object.mark_for_removal
    end
  end

  private

  def popup_msg
    @msg = Gosu::Image.from_text("#{@amount}", 30)
  end

end
