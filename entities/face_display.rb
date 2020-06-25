class FaceDisplay < Component
  WIDTH = 200
  HEIGHT = 60
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.5, 255, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
  end

  def draw
    draw_face
    draw_hp
    draw_hp_filter
  end

  def draw_face
    x1, x2, y1, y2 = face_coords
    face_image.draw(x1, y1, 300)
  end

  def draw_hp
    x1, x2, y1, y2 = hp_coords
    hp_image.draw(x1, y1, 300)
  end

  def draw_hp_filter
    x1, x2, y1, y2 = hp_coords
    if @character.health.health.to_f > 0
      x1 = x2 * (@character.health.health.to_f / @character.health.max_health.to_f)
    end
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      400)
  end

  private

  def face_coords
    x1 = PADDING
    x2 = 0
    y1 = $window.height - HEIGHT - PADDING
    y2 = 0
    [x1, x2, y1, y2]
  end

  def hp_coords
    x1 = PADDING + @@face_image.width
    x2 = PADDING + 320 + @@face_image.width
    y1 = $window.height - HEIGHT + PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def face_image
    @@face_image ||= Gosu::Image.new(Utils.media_path('sirase_mic.png'))
  end

  def hp_image
    @@hp_image ||= Gosu::Image.new(Utils.media_path('hp.png'))
  end

end
