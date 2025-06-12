class_name BallStateShot
extends BallState

const DURATION_SHOT := 1000
const SHOT_HEIGHT := 5.0
const SHOT_SPRITE_SCALE := 0.8

var time_since_shot := Time.get_ticks_msec()

func _enter_tree() -> void:
	if ball.velocity.x > 0:
		animation_player.play("roll")
	else:
		animation_player.play_backwards("roll")
		animation_player.advance(0)
	ball_sprite.scale.y = SHOT_SPRITE_SCALE
	ball.height = SHOT_HEIGHT
	time_since_shot = Time.get_ticks_msec()

func _exit_tree() -> void:
	ball_sprite.scale.y = 1.0

func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - time_since_shot > DURATION_SHOT:
		state_transition_requested.emit(Ball.State.FREEFORM)
	else:
		ball.move_and_collide(ball.velocity * delta)
