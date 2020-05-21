class GameObject
  attr_reader :x, :y, :location, :components

  def initialize(object_pool)
    @components = []
    @object_pool = object_pool
    @object_pool.objects << self
  end

  def update
    @components.map(&:update)
  end

  def draw(viewport)
    @components.each { |c| c.draw(viewport) }
  end

  def box
  end

  def collide
  end

  protected

  def object_pool
    @object_pool
  end
end
