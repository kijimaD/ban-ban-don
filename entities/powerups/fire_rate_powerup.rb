class FireRatePowerup < Powerup

  def pickup(object)
    if object.class == Character
      if object.fire_rate_modifier < 2
        object.fire_rate_modifier += 0.25
      end
      true
    end
  end

  def graphics
    :straight_gun
  end

end
