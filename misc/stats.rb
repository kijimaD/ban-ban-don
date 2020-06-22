class Stats
  attr_reader :score, :damage, :changed_at
  def initialize()
    @score = 0
    @damage = 0
    changed
  end

  def add_score(amount)
    @score += amount
    changed
  end

  def add_damage(amount)
    @damage += amount
    changed
  end

  def to_s
    "[score: #{@score}]"
  end

  private

  def changed
    @changed_at = Gosu.milliseconds
  end

end
