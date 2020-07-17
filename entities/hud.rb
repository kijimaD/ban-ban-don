class HUD
  attr_accessor :active

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @ammo_display = AmmoDisplay.new(self, @object_pool, @character)
    @weapon_display = WeaponDisplay.new(self, @object_pool, @character)
    @face_display = FaceDisplay.new(self, @object_pool, @character)
    @score_display = ScoreDisplay.new(self, @object_pool, @character)
    @speed_meter = SpeedMeter.new(self, @object_pool, @character)
    @radar = Radar.new(self, @object_pool, @character)
    @powerup = PowerupDisplay.new(self, @object_pool, @character)
  end

  def player=(character)
    @character = character
    @radar.object = character
    @ammo_display.character = character
    @face_display.character = character
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

  def images
    @@huds ||= Gosu::TexturePacker.load_json(
      Utils.media_path('huds_packed.json'))
  end

end
