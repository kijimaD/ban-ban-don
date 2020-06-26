class MagazinePowerup < Powerup

  def pickup(object)
    if object.class == Character
      if object.number_magazine < 100
        object.number_magazine += 1
      end
      true
    end
  end

  def graphics
    :magazine
  end
end
