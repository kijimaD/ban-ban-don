class RepairPowerup < Powerup

  def pickup(object)
    if object.class == Character
        object.health.restore
      true
    end
  end

  def graphics
    :repair
  end
end
