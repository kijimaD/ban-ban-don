class BulletSounds
  class << self
    def play(object, camera, fire_sound)
      volume, pan = Utils.volume_and_pan(object, camera)
      sound(fire_sound).play(object.object_id, pan, volume)
    end

    private

    def sound(fire_sound)
      @sound = StereoSample.new(Utils.media_path(fire_sound))
    end
  end
end
