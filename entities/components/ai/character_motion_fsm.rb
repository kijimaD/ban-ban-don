class CharacterMotionFSM
  STATE_CHANGE_DELAY = 500
  LOCATION_CHECK_DELAY = 5000

  def initialize(object, vision, gun)
    @object = object
    @vision = vision
    @gun = gun
    @roaming_state = CharacterRoamingState.new(object, vision)
    @fighting_state = CharacterFightingState.new(object, vision)
    @fleeing_state = CharacterFleeingState.new(object, vision, gun)
    @chasing_state = CharacterChasingState.new(object, vision, gun)
    @stuck_state = CharacterStuckState.new(object, vision, gun)
    @navigating_state = CharacterNavigatingState.new(object, vision)
    set_state(@roaming_state)
  end

  def draw(viewport)
    color = Gosu::Color::RED
    @image && @image.draw(
      @object.x - @image.width / 2,
      @object.y + @object.graphics.height / 2 -
      @image.height, 100, 1, 1, color)
  end

  def on_collision(with)
    @current_state.on_collision(with)
  end

  def on_damage(amount)
    if @current_state == @roaming_state
      set_state(@fighting_state)
    end
  end

  def update
    choose_state
    @current_state.update
  end

  def set_state(state)
    return unless state
    return if state == @current_state
    @last_state_change = Gosu.milliseconds
    @current_state = state
    state.enter
    if $debug
      @image = Gosu::Image.from_text(
        state.class.to_s, 18)
    end
  end

  def choose_state
    unless @vision.can_go_forward?
      unless @current_state == @stuck_state
        set_state(@navigating_state)
      end
    end

    change_delay = STATE_CHANGE_DELAY
    if @current_state == @stuck_state
      change_delay *= 5
    end
    now = Gosu.milliseconds
    return unless now - @last_state_change > change_delay
    if @last_location_update.nil?
      @last_location_update = now
      @last_location = @object.location
    end
    if now - @last_location_update > LOCATION_CHECK_DELAY
      unless @last_location.nil? || @current_state.waiting?
        if Utils.distance_between(*@last_location, *@object.location) < 20
          set_state(@stuck_state)
          @stuck_state.stuck_at = @object.location
          return
        end
      end
      @last_location_update = now
      @last_location = @object.location
    end
    if @gun.target
      if @object.health.health > 40
        if @gun.distance_to_target > BulletPhysics::MAX_DIST
          new_state = @chasing_state
        else
          new_state = @fighting_state
        end
      else
        if @fleeing_state.can_flee?
          new_state = @fleeing_state
        else
          new_state = @fighting_state
        end
      end
    else
      new_state = @roaming_state
    end
    set_state(new_state)
  end
end
