module Utils
  HEARING_DISTANCE = 1000.0
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]

  def self.media_path(file)
    File.join(File.dirname((File.dirname(__FILE__))), 'media', file)
  end

  def self.media_path_sound(file)
    media_path("sounds/#{file}")
  end

  def self.load_json(file)
    File.open(media_path(file)) do |j|
      JSON.load(j, { symbolize_names: true })
    end
  end

  def self.parse_json(file)
    File.open(media_path(file)) do |j|
      JSON.parse(j.read, { symbolize_names: true })
    end
  end

  def self.load_all
    root_dir = File.dirname((File.dirname(__FILE__)))
    require_pattern = File.join(root_dir, '**/*.rb')
    @failed = []

    # Dynamically require everything
    Dir.glob(require_pattern).each do |f|
      next if f.end_with?('/main.rb')
      begin
        load f.gsub("#{root_dir}/", '')
      rescue
        # May fail if parent class not required yet
        @failed << f
      end
    end
  end

  def self.title_font
    media_path('GN-KillGothic-U-KanaNA.ttf')
  end

  def self.main_font()
    media_path('RictyDiminished-Bold.ttf')
  end

  def self.track_update_interval
    now = Gosu.milliseconds
    @update_interval = (now - (@last_update ||= 0)).to_f
    @last_update = now
  end

  def self.update_interval
    @update_interval ||= $window.update_interval
  end

  def self.adjust_speed(speed)
    speed * update_interval / 33.33
  end

  def self.button_down?(button)
    @buttons ||= {}
    now = Gosu.milliseconds
    now = now - (now % 150)
    if $window.button_down?(button)
      @buttons[button] = now
      true
    elsif @buttons[button]
      if now == @buttons[button]
        true
      else
        @buttons.delete(button)
        false
      end
    end
  end

  def self.button_up?(button)
    @buttons ||= {}
    now = Gosu.milliseconds
    now = now - (now % 150)
    if $window.button_down?(button)
      @buttons[button] = now
      false
    elsif @buttons[button]
      if now == @buttons[button]
        true
      else
        @buttons.delete(button)
        false
      end
    end
  end

  def self.rotate(angle, around_x, around_y, *points)
    result = []
    angle = angle * Math::PI / 180.0
    points.each_slice(2) do |x, y|
      r_x = Math.cos(angle) * (around_x - x) -
            Math.sin(angle) * (around_y - y) + around_x
      r_y = Math.sin(angle) * (around_x - x) +
            Math.cos(angle) * (around_y - y) + around_y
      result << r_x
      result << r_y
    end
    result
  end

  # http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly
  def self.point_in_poly(testx, testy, *poly)
    nvert = poly.size / 2 # Number of vertices in poly
    vertx = []
    verty = []
    poly.each_slice(2) do |x, y|
      vertx << x
      verty << y
    end
    inside = false
    j = nvert - 1
    (0..nvert - 1).each do |i|
      if (((verty[i] > testy) != (verty[j] > testy)) &&
         (testx < (vertx[j] - vertx[i]) * (testy - verty[i]) /
         (verty[j] - verty[i]) + vertx[i]))
        inside = !inside
      end
      j = i
    end
    inside
  end

  def self.distance_between(x1, y1, x2, y2)
    dx = x1 - x2
    dy = y1 - y2
    Math.sqrt(dx * dx + dy * dy)
  end

  def self.angle_between(x, y, target_x, target_y)
    dx = target_x - x
    dy = target_y - y
    (180 - Math.atan2(dx, dy) * 180 / Math::PI) + 360 % 360
  end

  def self.point_at_distance(source_x, source_y, angle, distance)
    angle = (90 - angle) * Math::PI / 180
    x = source_x + Math.cos(angle) * distance
    y = source_y - Math.sin(angle) * distance
    [x, y]
  end

  def self.mark_corners(box)
    i = 0
    box.each_slice(2) do |x, y|
      color = DEBUG_COLORS[i]
      $window.draw_triangle(
        x - 3, y - 3, color,
        x,     y,     color,
        x + 3, y - 3, color,
        100)
      i = (i + 1) % 4
    end
  end

  def self.volume(object, camera)
    return 1 if object == camera.target
    distance = Utils.distance_between(
      camera.target.x, camera.target.y,
      object.x, object.y)
    distance = [(HEARING_DISTANCE - distance), 0].max
    distance / HEARING_DISTANCE
  end

  def self.pan(object, camera)
    return 0 if object == camera.target
    pan = object.x - camera.target.x
    sig = pan > 0 ? 1 : -1
    pan = (pan % HEARING_DISTANCE) / HEARING_DISTANCE
    if sig > 0
      pan
    else
      -1 + pan
    end
  end

  def self.volume_and_pan(object, camera)
    [volume(object, camera), pan(object, camera)]
  end

  def self.collides_with_poly?(poly, *box)
    if poly
      if poly.size == 2
        px, py = poly
        return Utils.point_in_poly(px, py, *box)
      end
      poly.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *box)
      end
      box.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *poly)
      end
    end
    false
  end

  def self.tile_coords(x, y)
    col = (Map::OFFSET_X + y * 2 - x) / 2
    row = ((x + col) - Map::TILE_HEIGHT) - Map::OFFSET_X
    t_x = (col / Map::TILE_HEIGHT).round
    t_y = (row / Map::TILE_HEIGHT).round
    [t_x, t_y]
  end

end
