class_name BallStateFreeform
extends BallState

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_body_entered.bind())

func on_body_entered(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)

func _physics_process(delta: float) -> void:
	set_animation_by_velocity()
	var friction := ball.friction_air if ball.height > 0 else ball.friction_ground
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, Ball.BOUNCINESS)
	move_and_bounce(delta)

func can_air_interact() -> bool:
	return true
