class ExplosionSounds
  class << self
    def play(object, camera)
      volume, pan = Utils.volume_and_pan(object, camera)
      sound.play(object.object_id, pan, volume)
    end

    private

    def sound
      @@sound ||= StereoSample.new(Utils.media_path_sound('explosion.mp3'))
    end
  end
end
