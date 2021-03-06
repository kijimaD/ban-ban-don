class PlayState < GameState
  RESPAWN_DELAY = 20
  attr_accessor :update_interval, :object_pool, :character, :announce,
                :difficulty, :difficulty_factor, :character_parameters

  def initialize(settings = {"difficulty"=> 0, "chara"=> "sirase"})
    @object_pool = ObjectPool.new(Map.bounding_box)
    @map = Map.new(@object_pool)
    @map.spawn_points(10)
    @camera = Camera.new
    @object_pool.camera = @camera
    @difficulty = settings["difficulty"]
    difficulty_factors = { 'easy' => 0.3, 'normal' => 0.5, 'hard' => 0.7, 'powerful' => 1.0 }
    @difficulty_factor = difficulty_factors[@difficulty].to_i
    @player_selected_character = settings["chara"]
    load_character_parameters
    if $debug
      number_of_people = 0
    else
      number_of_people = 1
    end
    create_characters(number_of_people)
    @announce = Announce.new(@character, @ai, settings)
    Damage.new(@object_pool, 0, 0).mark_for_removal # initialize damage graphics
  end

  def enter
    @hud.active = true
  end

  def leave
    StereoSample.stop_all
    @hud.active = false
  end

  def update
    StereoSample.cleanup
    @object_pool.update_all
    @camera.update
    @hud.update
    @announce.update
    update_caption
    spawn_enemy
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
      [x1 - Map::TILE_WIDTH, y1 - Map::TILE_HEIGHT])
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
    @announce.draw
  end

  def button_down(id)
    if id == Gosu::KbQ
      leave
      $window.close
    end
    if id == Gosu::KbEscape
      pause = PauseState.instance
      pause.play_state = self
      GameState.switch(pause)
    end
    if id == Gosu::KbF1
      $debug = !$debug
    end
    if id == Gosu::KbT && $debug
      t = Character.new(self, @object_pool,
                        AiInput.new(self, @object_pool), load_character_parameters['black_ball'])
      x, y = @camera.mouse_coords
      t.move(x, y)
    end
    if id == Gosu::KbG && $debug
      x, y = @camera.mouse_coords
      g = Tree.new(@object_pool, x, y, 0.7)
      g.move(x, y)
    end
    if id == Gosu::KbSpace && $debug
      StereoSample.stop_all
      Utils.load_all
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
  end

  def random_character
    load_character_parameters["#{load_character_parameters.keys.sample}"]
  end

  private

  def update_caption
    now = Gosu.milliseconds
    if now - (@caption_updated_at || 0) > 1000
      $window.caption = 'BBD' <<
                        "[FPS: #{Gosu.fps}. " <<
                        "@ #{@character.x.round}:#{@character.y.round}]"
      @caption_updated_at = now
    end
  end

  def create_characters(amount)
    @map.spawn_points(amount * 3)
    @character = Character.new(self, @object_pool, PlayerInput.new(
                                 self, @camera, @object_pool), player_selected_character)
    @ai = []
    amount.times do |i|
      @ai << (Character.new(self, @object_pool, AiInput.new(
                              self, @object_pool), load_character_parameters["black_ball"]))
    end
    @camera.target = @character
    @hud = HUD.new(@object_pool, @character)
    random_character
  end

  def spawn_enemy
    if object_pool.character_respawn_queue.respawn_queue.length < @difficulty_factor + 1
      x, y = @map.spawn_point
      object_pool.character_respawn_queue.enqueue(
        RESPAWN_DELAY,
        Character, x, y, self)
    end
  end

  def load_character_parameters
    @character_parameters ||= Utils.load_json("characters_parameter.json")
  end

  def player_selected_character
    load_character_parameters["#{@player_selected_character}"]
  end

end
