class_name BallStateFreeform
extends BallState

const FRICTION_AIR := 35.0
const FRICTION_GROUND := 250.0
const BOUNCINESS := 0.8

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_body_entered.bind())

func on_body_entered(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)

func _physics_process(delta: float) -> void:
	set_animation_by_velocity()
	var friction := FRICTION_AIR if ball.height > 0 else FRICTION_GROUND
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, BOUNCINESS)
	ball.move_and_collide(ball.velocity * delta)
