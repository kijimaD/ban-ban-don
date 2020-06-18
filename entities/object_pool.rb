class ObjectPool
  attr_accessor :objects, :map, :camera

  def initialize
    @objects = []
  end

  def nearby(object, max_distance, min_distance = 0)
    @objects.select do |obj|
      distance = Utils.distance_between(
        obj.x, obj.y, object.x, object.y)
      obj != object && distance < max_distance && distance > min_distance
    end
  end

end
