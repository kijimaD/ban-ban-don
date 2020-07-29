class ScoreRecord

  def initialize(character, settings)
    @character = character
    @difficulty = settings[0]
    @name = settings[1]
  end

  def record
    open(Utils.media_path("score.csv"), "a"){ |f|
      f.puts "#{@name},#{@difficulty},#{@character.input.stats.score}"
    }
  end

end
