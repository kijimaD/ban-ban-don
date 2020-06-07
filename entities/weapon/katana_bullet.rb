class KatanaBullet < BaseBullet
  attr_accessor :explodable

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    @fire_sound = "sword-gesture2.mp3"
    @bullet_image = "katana"
    @bullet_trajectory = ""
    @damage = 1.2
    @range = 2.0
    @speed = 2.0
    @explodable = 0
  end

end
