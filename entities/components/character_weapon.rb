class CharacterWeapon < Component
  attr_accessor :bullet, :text

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    if @object.weapon_type == 0
      @bullet = HandgunBullet
      @text = "Handgun"
    elsif @object.weapon_type == 1
      @bullet = LauncherBullet
      @text = "Launcher"
    elsif @object.weapon_type == 2
      @bullet = KatanaBullet
      @text = "Katana"
    end
  end

end
