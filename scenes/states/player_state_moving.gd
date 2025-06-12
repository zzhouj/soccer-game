class_name PlayerStateMoving
extends PlayerState

func _process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		pass
	else:
		handle_player_movement()
	player.set_movement_animation()
	player.set_heading()

func handle_player_movement() -> void:
	var direction = KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = direction * player.speed
	if player.has_ball():
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			state_transition_requested.emit(Player.State.PREPPING_SHOT)
	else:
		if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			state_transition_requested.emit(Player.State.TACKLING)
