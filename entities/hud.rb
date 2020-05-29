class HUD

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @ammo_display = AmmoDisplay.new(@object_pool, @character)
  end

  def update
    @ammo_display.update
  end

  def draw
    @ammo_display.draw
  end

end
