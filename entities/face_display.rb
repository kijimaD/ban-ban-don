class FaceDisplay < Component
  WIDTH = 200
  HEIGHT = 60
  PADDING = 10
  BACKGROUND = Gosu::Color.new(255 * 0.66, 0, 0, 0)
  FONT_COLOR = Gosu::Color::WHITE

  def initialize(object_pool, character)
    @object_pool = object_pool
    @character = character
  end

  def draw
    draw_face
  end

  def draw_face
    x1, x2, y1, y2 = face_coords
    face_image.draw(x1, y1, 300)
  end

  private

  def face_coords
    x1 = PADDING
    x2 = 0
    y1 = $window.height - HEIGHT - PADDING
    y2 = 0
    [x1, x2, y1, y2]
  end

  def face_image
    @@image ||= Gosu::Image.new(Utils.media_path('sirase_mic.png'))
  end

end
