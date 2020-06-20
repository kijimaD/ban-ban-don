class CharacterSpeedPowerup < Powerup

  def pickup(object)
    if object.class == Character
      if object.speed_modifier < 1.5
        object.speed_modifier += 0.10
      end
      true
    end
  end

  def graphics
    :wingman
  end
end
