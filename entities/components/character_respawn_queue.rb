# TODO: Unity powerup_respawn_queue.
class CharacterRespawnQueue
  RESPAWN_DELAY = 2
  attr_reader :respawn_queue

  def initialize
    @respawn_queue = {}
    @last_respawn = Gosu.milliseconds
  end

  def enqueue(delay_seconds, type, x, y, play_state)
    respawn_at = Gosu.milliseconds + delay_seconds * 1000
    @respawn_queue[respawn_at.to_i] = [type, x, y]
    @play_state = play_state
  end

  def respawn(object_pool)
    now = Gosu.milliseconds
    return if now - @last_respawn < RESPAWN_DELAY
    @respawn_queue.keys.each do |k|
      next if k > now
      type, x, y = @respawn_queue.delete(k)
      t = type.new(@play_state, object_pool,
                   AiInput.new(@play_state, object_pool), @play_state.character_parameters['black_ball'])
      t.move(x, y)
    end
    @last_respawn = now
  end
end
