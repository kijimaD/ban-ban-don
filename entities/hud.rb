class HUD

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @ammo_display = AmmoDisplay.new(@object_pool, @character)
    @speed_meter = SpeedMeter.new(@object_pool, @character)
    @radar = Radar.new(@object_pool, @character)
  end

  def update
    @ammo_display.update
    @speed_meter.update
    @radar.update
  end

  def draw
    @ammo_display.draw
    @speed_meter.draw
    @radar.draw
  end

end
