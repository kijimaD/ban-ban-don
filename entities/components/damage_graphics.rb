class DamageGraphics < Component
  def initialize(object_pool)
    super
    i = rand(1..4)
    @image = images.frame("damage#{i}.png")
    @angle = rand(0..360)
  end

  def draw(viewport)
    if @image
      @image.draw_rot(x, y, depth, @angle)
    end
  end

  private

  def images
    @@images ||= Gosu::TexturePacker.load_json(
      Utils.media_path("damages_packed.json"))
  end
end
