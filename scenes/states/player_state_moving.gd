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
	if player.velocity != Vector2.ZERO:
		teammate_detection_area.rotation = player.velocity.angle()
	if player.has_ball():
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
			transition_state(Player.State.PASSING)
		elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			transition_state(Player.State.PREPPING_SHOT)
	elif ball.can_air_interact():
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			if player.velocity == Vector2.ZERO:
				pass
			else:
				transition_state(Player.State.HEADER)
