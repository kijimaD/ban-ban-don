class DamagePopupGraphics < Component

  def initialize(object, amount)
    super(object)
    @amount = amount
    @frame = 0
    @offset = 0
  end

  def draw(viewport)
    if @frame < 20
      if @frame % 5 == 0
        @offset += 1
      end
      popup_msg.draw(x, y - @offset * 10, 1)
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
