class ObjectPool
  attr_accessor :objects, :map, :camera,
                :powerup_respawn_queue, :character_respawn_queue

  def initialize(box)
    @tree = QuadTree.new(box)
    @powerup_respawn_queue = PowerupRespawnQueue.new
    @character_respawn_queue = CharacterRespawnQueue.new
    @objects = []
  end

  def size
    @objects.size
  end

  def add(object)
    @objects << object
    @tree.insert(object)
  end

  def tree_remove(object)
    @tree.remove(object)
  end

  def tree_insert(object)
    @tree.insert(object)
  end

  def update_all
    @objects.map(&:update)
    @objects.reject! do |o|
      if o.removable?
        @tree.remove(o)
        true
      end
    end
    @powerup_respawn_queue.respawn(self)
    @character_respawn_queue.respawn(self)
  end

  def nearby_point(cx, cy, max_distance, min_distance = 0, object = nil)
    hx, hy = cx + max_distance, cy + max_distance
    # Fast, rough results
    results = @tree.query_range(
      AxisAlignedBoundingBox.new([cx, cy], [hx, hy]))
    # Sift through to select fine-grained results
    results.select do |o|
      o != object &&
        Utils.distance_between(
          o.x, o.y, cx, cy) <= max_distance &&
        Utils.distance_between(
          o.x, o.y, cx, cy) >= min_distance
    end
  end

  def nearby(object, max_distance, min_distance = 0)
    cx, cy = object.location
    nearby_point(cx, cy, max_distance, min_distance, object)
  end

  def query_range(box)
    @tree.query_range(box)
  end

end
