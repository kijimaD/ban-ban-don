class HUD
  Z = 500
  attr_accessor :active

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
    @args = {hud:self, object_pool:object_pool, character:character}
    @ammo_display = AmmoDisplay.new(@args)
    @weapon_display = WeaponDisplay.new(@args)
    @face_display = FaceDisplay.new(@args)
    @score_display = ScoreDisplay.new(@args)
    @speed_meter = SpeedMeter.new(@args)
    @radar = Radar.new(@args)
    @powerup = PowerupDisplay.new(@args)
  end

  def player=(character)
    @character = character
    @ammo_display.character = character
    @weapon_display.character = character
    @face_display.character = character
    @score_display.character = character
    @speed_meter.character = character
    @powerup.character = character
    @radar.object = character
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
