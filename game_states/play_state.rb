# coding: utf-8
class PlayState < GameState
  attr_accessor :update_interval, :object_pool, :character

  def initialize
    @object_pool = ObjectPool.new(Map.bounding_box)
    @map = Map.new(@object_pool)
    @map.spawn_points(10)
    @camera = Camera.new
    @object_pool.camera = @camera
    create_characters(4)
    @object_pool.camera = @camera
    Damage.new(@object_pool, 0, 0).mark_for_removal
  end

  def enter
    RubyProf.start if ENV['ENABLE_PROFILING']
  end

  def leave
    if ENV['ENABLE_PROFILING']
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT)
    end
  end

  def update
    StereoSample.cleanup
    @object_pool.update_all
    @camera.update
    @hud.update
    update_caption
  end

  def draw
    cam_x = @camera.x
    cam_y = @camera.y
    off_x = $window.width / 2 - cam_x
    off_y = $window.height / 2 - cam_y
    viewport = @camera.viewport
    x1, x2, y1, y2 = viewport
    box = AxisAlignedBoundingBox.new(
      [x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2],
      [x1 - Map::TILE_SIZE, y1 - Map::TILE_SIZE])
    $window.translate(off_x, off_y) do
      zoom = @camera.zoom
      $window.scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(viewport)
        @object_pool.query_range(box).map do |o|
          o.draw(viewport)
        end
      end
    end
    @camera.draw_crosshair
    @hud.draw
  end

  def button_down(id)
    if id == Gosu::KbQ
      leave
      $window.close
    end
    if id == Gosu::KbT
      t = Character.new(@object_pool,
                   AiInput.new(@object_pool))
      x, y = @camera.mouse_coords
      t.move(x, y)
    end
    if id == Gosu::KbEscape
      GameState.switch(MenuState.instance)
    end
  end

  private

  def update_caption
    now = Gosu.milliseconds
    if now - (@caption_updated_at || 0) > 1000
      $window.caption = 'ばんばんどーん！' <<
                        "残: #{@character.number_ammo}" <<
                        "[FPS: #{Gosu.fps}. " <<
                        "Character @ #{@character.x.round}:#{@character.y.round}]"
      @caption_updated_at = now
    end
  end

  def create_characters(amount)
    @map.spawn_points(amount * 3)
    @character = Character.new(@object_pool, PlayerInput.new(@camera, @object_pool))
    amount.times do |i|
      Character.new(@object_pool, AiInput.new(
                      @object_pool))
    end
    @camera.target = @character
    @hud = HUD.new(@object_pool, @character)
  end

end
