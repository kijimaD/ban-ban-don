class FaceDisplay < Component
  Z = 300
  WIDTH = 200
  HEIGHT = 60
  PADDING = 10
  FILTER = Gosu::Color.new(255 * 0.8, 255, 0, 0)
  BACKGROUND = Gosu::Color.new(255 * 0.8, 255, 255, 255)
  FONT_COLOR = Gosu::Color::RED
  attr_accessor :character

  def initialize(object, object_pool, character)
    @object = object
    @object_pool = object_pool
    @character = character
  end

  def draw
    draw_face
    # draw_face_bg
    draw_hp
    draw_hp_filter
    draw_magazine
    draw_magazine_msg
  end

  def draw_face
    x1, x2, y1, y2 = face_coords
    face_image.draw(x1, y1, Z)
  end

  def draw_face_bg
    x1, x2, y1, y2 =face_coords
    $window.draw_quad(
      x1, y1, BACKGROUND,
      x2, y1, BACKGROUND,
      x2, y2, BACKGROUND,
      x1, y2, BACKGROUND,
      Z)
  end

  def draw_hp
    x1, x2, y1, y2 = hp_coords
    hp_image.draw(x1, y1, Z)
  end

  def draw_hp_filter
    x1, x2, y1, y2 = hp_coords
    if @character.health.health > 0
      hp_image_len = hp_image.width * (@character.health.health.to_f / @character.health.initial_health.to_f)
      x1 = PADDING + face_image.width + hp_image_len
    end
    $window.draw_quad(
      x1, y1 + 1, FILTER,
      x2, y1 + 1, FILTER,
      x2, y2 - 1, FILTER,
      x1, y2 - 1, FILTER,
      Z)
  end

  def draw_magazine
    x1, x2, y1, y2 = magazine_coords
    magazine_image.draw(x1, y1, Z)
  end

  def draw_magazine_msg
    x1, x2, y1, y2 = magazine_coords
    magazine_msg.draw(
      x2, y1 + PADDING, Z, 1.0, 1.0, FONT_COLOR
    )
  end

  private

  def face_coords
    x1 = PADDING
    x2 = PADDING + face_image.width
    y1 = $window.height - HEIGHT - PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def hp_coords
    x1 = PADDING + face_image.width
    x2 = PADDING + hp_image.width + face_image.width
    y1 = $window.height - HEIGHT + PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def magazine_coords
    x1 = PADDING + face_image.width + hp_image.width + PADDING
    x2 = PADDING + face_image.width + hp_image.width + magazine_image.width
    y1 = $window.height - HEIGHT + PADDING
    y2 = $window.height - PADDING
    [x1, x2, y1, y2]
  end

  def face_image
    @@face_image ||= @character.graphics.charas.frame('icon.png')
  end

  def hp_image
    @@hp_image ||= object.images.frame('hp.png')
  end

  def magazine_image
    @@magazine_image ||= object.images.frame('magazine.png')
  end

  def magazine_msg
    @msg = Gosu::Image.from_text("x#{@character.number_magazine.to_i}", 30, options = { font: Utils.title_font })
  end

end
