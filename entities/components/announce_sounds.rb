class AnnounceSounds
  class << self

    def play
      sound.play
    end

    def sound
      @@sound ||= Gosu::Sample.new(
        Utils.media_path_sound('win.wav'))
    end
  end
end
