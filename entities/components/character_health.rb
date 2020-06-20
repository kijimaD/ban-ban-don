class CharacterHealth < Component
  attr_accessor :health
  MAX_HEALTH = 50000

  def initialize(object, object_pool)
    super(object)
    @object = object
    @object_pool = object_pool
    @health = MAX_HEALTH
    @health_updated = true
    @last_damage = Gosu.milliseconds
  end

  def update
    update_image
  end

  def draw(viewport)
    @image.draw(
      x - @image.width / 2,
      y - object.graphics.height / 2 -
      @image.height, 100)
  end

  def update_image
    if @health_updated
      if dead?
        text = '+'
        font_size = 25
      else
        text = hp_gauge(@health)
        font_size = 18
      end
      @image = Gosu::Image.from_text(text, font_size)
      @health_updated = false
    end
  end

  def dead?
    @health < 1
  end

  def inflict_damage(amount)
    if @health > 0
      @health_updated = true
      @health = [@health - amount.to_i, 0].max
      if @health < 1
        Explosion.new(@object_pool, x, y)
      end
    end
  end

  def hp_gauge(health)
    mark = "*"
    mark * (health.to_f / MAX_HEALTH.to_f * 10).round
  end

end
