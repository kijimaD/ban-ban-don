class HUD

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @ammo_display = AmmoDisplay.new(@object_pool, @character)
    @weapon_display = WeaponDisplay.new(@object_pool, @character)
    @face_display = FaceDisplay.new(@object_pool, @character)
    @score_display = ScoreDisplay.new(@object_pool, @character)
    @speed_meter = SpeedMeter.new(@object_pool, @character)
    @radar = Radar.new(@object_pool, @character)
    @powerup = PowerupDisplay.new(@object_pool, @character)
  end

  def update
    @radar.update
  end

  def draw
    @ammo_display.draw
    @weapon_display.draw
    @score_display.draw
    @face_display.draw
    @speed_meter.draw
    @radar.draw
    @powerup.draw
  end

end
