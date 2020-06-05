class CharacterWeapon < Component
  attr_accessor :bullet

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @object = object

    if @object.weapon_type == 0
      @bullet = HandgunBullet
    elsif @object.weapon_type == 1
      @bullet = LauncherBullet
    elsif @object.weapon_type == 2
      @bullet = KatanaBullet
    end
  end

end
