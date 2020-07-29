class ScoreRecord

  def initialize(character, settings)
    @character = character
    @difficulty = settings["difficulty"]
    @name = settings["chara"]
  end

  def record
    open(Utils.media_path("score.csv"), "a"){ |f|
      f.puts "#{@difficulty},#{@character.input.stats.score},#{@name}"
    }
  end

end
