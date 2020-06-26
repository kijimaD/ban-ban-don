class DemoState < PlayState
  attr_accessor :character

  def enter
  end

  def update
    super
  end

  def draw
    super
  end

  def button_down(id)
    super
    if id == Gosu::KbSpace
      target_character = @characters.reject do |t|
        t == @camera.target
      end.sample
      switch_to_character(target_character)
    end
  end

  private

  def create_characters(amount)
    @map.spawn_points(amount * 3)
    @characters = []
    amount.times do |i|
      @characters << Character.new(@object_pool, AiInput.new(
                                     @object_pool))
    end
    target_character = @characters.sample
    @hud = HUD.new(@object_pool, target_character)
    @hud.active = false
    switch_to_character(target_character)
  end

  def switch_to_character(character)
    @camera.target = character
    @hud.player = character
    self.character = character
  end

end
