extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("attack")
	add_state("retreat")
	call_deferred("set_state", "idle")

# Contains state logic.
func _state_logic(delta : float) -> void:
	match state:
		states.idle:
			pass
		states.attack:
			parent.accelerate_to_player(delta)
			parent.apply_velocity(delta)
		states.retreat:
			parent.accelerate_to_start(delta)
			parent.apply_velocity(delta)

# Return value will be used to change state.
func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.is_player_in_sight:
				if parent.is_player_in_ray():
					return states.attack
		states.attack:
			if parent.detected:
				return states.retreat
			if not parent.is_player_in_sight:
				return states.retreat
			if not parent.is_player_in_ray():
				return states.retreat
		states.retreat:
			if parent.is_in_start_pos_range():
				return states.idle
	return null

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.idle:
			parent.velocity = Vector2()
			parent.reset_position()
		states.attack:
			pass
		states.retreat:
			parent.retreat_sfx.play()
			parent.retreat_timer.start()

# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state) -> void:
	match old_state:
		states.idle:
			pass
		states.attack:
			pass
		states.retreat:
			parent.retreat_timer.stop()
