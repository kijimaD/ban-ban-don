# coding: utf-8
class PlayState < GameState

  def initialize
    @map = Map.new
    @character = Character.new(@map)
    @camera = Camera.new(@character)
    @bullets = []
    @explosions = []
  end

  def update
    bullet = @character.update(@camera)
    @bullets << bullet if bullet
    @bullets.map(&:update)
    @bullets.reject!(&:done?)
    @camera.update
    $window.caption = 'ばんばんどーん！ ' <<
      "[FPS: #{Gosu.fps}. Character @ #{@character.x.round}:#{@character.y.round}]"
  end

  def draw
    cam_x = @camera.x
    cam_y = @camera.y
    off_x =  $window.width / 2 - cam_x
    off_y =  $window.height / 2 - cam_y
    $window.translate(off_x, off_y) do
      zoom = @camera.zoom
      $window.scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(@camera)
        @character.draw
        @bullets.map(&:draw)
      end
    end
    @camera.draw_crosshair
  end

  def button_down(id)
    if id == Gosu::MsLeft
      bullet = @character.shoot(*@camera.mouse_coords)
      @bullets << bullet if bullet
    end
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbEscape
      GameState.switch(MenuState.instance)
    end
  end

end
