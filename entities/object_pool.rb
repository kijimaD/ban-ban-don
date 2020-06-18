class ObjectPool
  attr_accessor :objects, :map, :camera

  def initialize
    @objects = []
  end

  def nearby(object, max_distance, min_distance = 0)
    @objects.select do |obj|
      obj != object &&
        (obj.x - object.x).abs < max_distance &&
        (obj.y - object.y).abs < max_distance &&
        (obj.x - object.x).abs > min_distance &&
        (obj.y - object.y).abs > min_distance &&
        Utils.distance_between(
          obj.x, obj.y, object.x, object.y) < max_distance
    end
  end

  def non_effects
    @object.reject(&:effect?)
  end
end
