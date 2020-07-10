class DamagePopupGraphics < Component

  def initialize(object, amount)
    super(object)
    @amount = amount
    @frame_remain = 10
  end

  def draw(viewport)
    if @frame_remain > 0
      popup_msg.draw(object.x, object.y, 1)
      @frame_remain -= 1
    else
      object.mark_for_removal
    end
  end

  private

  def popup_msg
    @msg = Gosu::Image.from_text("#{@amount}", 30)
  end

end
