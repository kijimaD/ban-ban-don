class BulletSounds
  class << self                 # this is what??
    def play(fire_sound)
      sound(fire_sound).play
    end

    private

    def sound(fire_sound)
      @@sound ||= Gosu::Sample.new(
        $window, Utils.media_path(fire_sound))
    end
  end
end
