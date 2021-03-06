class CharacterSounds < Component

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
  end

  def update
    id = object.object_id
    if object.physics.moving?
      move_volume = Utils.volume(
        object, @object_pool.camera)
      pan = Utils.pan(object, @object_pool.camera)
      if driving_sound.paused?(id)
        driving_sound.resume(id)
      elsif driving_sound.stopped?(id)
        driving_sound.play(id, pan, 0.5, 1, true)
      end
      driving_sound.volume_and_pan(id, move_volume * 0.2, pan)
    else
      if driving_sound.playing?(id)
        driving_sound.pause(id)
      end
    end
  end

  def collide
    vol, pan = Utils.volume_and_pan(object, @object_pool.camera)
    crash_sound.play(self.object_id, pan, vol)
  end

  def reload
    vol, pan = Utils.volume_and_pan(object, @object_pool.camera)
    reload_sound.play(self.object_id, pan, vol)
  end

  def out_of_ammo
    vol, pan = Utils.volume_and_pan(object, @object_pool.camera)
    out_of_ammo_sound.play(self.object_id, pan, vol)
  end

  private

  def driving_sound
    @@driving_sound ||= StereoSample.new(Utils.media_path_sound('dash-soil1.mp3'))
  end

  def crash_sound
    @@crash_sound ||= StereoSample.new(Utils.media_path_sound('crash.ogg'))
  end

  def hit_bullet_sound
    @@hit_bullet_sound ||= StereoSample.new(Utils.media_path_sound('bullet-hit.wav'))
  end

  def reload_sound
    @@reload_sound ||= StereoSample.new(Utils.media_path_sound('reload.mp3'))
  end

  def out_of_ammo_sound
    @@out_of_ammo_sound ||= StereoSample.new(Utils.media_path_sound('trigger.wav'))
  end

end
