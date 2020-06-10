class LauncherBullet < BaseBullet

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    @fire_sound = "largerifle-firing1.mp3"
    @bullet_image = "bullet_launcher.png"
    @bullet_trajectory = "smoke"
    @damage = 1.2
    @range = 3.0
    @speed = 0.6
    @explodable = 1
  end

end
