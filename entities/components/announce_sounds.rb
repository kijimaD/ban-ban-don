class AnnounceSounds
  class << self

    def win
      win_sound.play
    end

    def lose
      lose_sound.play
    end

    def win_sound
      @@win_sound ||= Gosu::Sample.new(
        Utils.media_path_sound('win.wav'))
    end

    def lose_sound
      @@lose_sound ||= Gosu::Sample.new(
        Utils.media_path_sound('lose.wav'))
    end
  end
end
