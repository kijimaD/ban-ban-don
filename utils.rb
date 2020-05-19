module Utils

  def self.media_path(file)
    File.join(File.dirname(__FILE__), 'media', file)
  end

end
