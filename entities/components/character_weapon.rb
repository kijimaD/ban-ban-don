class CharacterWeapon < Component
  attr_accessor :bullet, :text, :shoot_delay

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    # TODO: ugly
    if @object.weapon_type == 0
      @bullet = HandgunBullet
      @text = "Handgun"
      @shoot_delay = 200
    elsif @object.weapon_type == 1
      @bullet = LauncherBullet
      @text = "Launcher"
      @shoot_delay = 500
    elsif @object.weapon_type == 2
      @bullet = KatanaBullet
      @text = "Katana"
      @shoot_delay = 500
    end
  end

end
