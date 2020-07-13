class DamagePopup < GameObject

  def initialize(object_pool, x, y, amount)
    super(object_pool, x, y)
    @object_pool = object_pool
    DamagePopupGraphics.new(self, amount)
  end

  def mark_for_removal
    super
  end

  def box
    [0, 0]
  end

end
