class HUD

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @ammo_display = AmmoDisplay.new(@object_pool, @character)
    @speed_meter = SpeedMeter.new(@boject_pool, @character)
  end

  def update
    @ammo_display.update
    @speed_meter.update
  end

  def draw
    @ammo_display.draw
    @speed_meter.draw
  end

end
