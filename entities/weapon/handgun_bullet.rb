class HandgunBullet < BaseBullet

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    @text = "Handgun"
    @fire_sound = "handgun-firing1.mp3"
    @bullet_image = "bullet_handgun.png"
    @bullet_trajectory = ""
    @shoot_delay = 200
    @damage = 1.2
    @range = 2.0
    @speed = 2.0
    @explodable = 0
  end

end
