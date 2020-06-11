class KatanaBullet < BaseBullet
  attr_accessor :explodable

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    @text = "Katana"
    @fire_sound = "katana-gesture1.mp3"
    @bullet_image = "bullet_katana.png"
    @bullet_trajectory = ""
    @shoot_delay = 500
    @damage = 1.2
    @range = 2.0
    @speed = 2.0
    @explodable = 0
  end

end
