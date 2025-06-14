class_name BallState
extends Node

const GRAVITY := 10.0

signal state_transition_requested(new_state: Ball.State)

var ball: Ball = null
var animation_player: AnimationPlayer = null
var player_detection_area: Area2D = null
var ball_sprite: Sprite2D = null
var carrier: Player = null

func setup(ctx_ball: Ball, ctx_animation_player: AnimationPlayer, ctx_player_detection_area: Area2D, ctx_ball_sprite: Sprite2D, ctx_carrier: Player) -> void:
	ball = ctx_ball
	animation_player = ctx_animation_player
	player_detection_area = ctx_player_detection_area
	ball_sprite = ctx_ball_sprite
	carrier = ctx_carrier

func set_animation_by_velocity() -> void:
	if ball.velocity == Vector2.ZERO:
		animation_player.play("idle")
	elif ball.velocity.x > 0:
		animation_player.play("roll")
	else:
		animation_player.play_backwards("roll")
		animation_player.advance(0)

func process_gravity(delta: float, bounciness: float = 0.0) -> void:
	if ball.height > 0 or ball.height_velocity > 0:
		ball.height_velocity -= GRAVITY * delta
		ball.height += ball.height_velocity
		if ball.height <= 0:
			ball.height = 0
			if bounciness > 0 and ball.height_velocity < 0:
				ball.height_velocity = -ball.height_velocity * bounciness
				ball.velocity *= bounciness
			else:
				ball.height_velocity = 0

func move_and_bounce(delta: float) -> void:
	var collision = ball.move_and_collide(ball.velocity * delta)
	if collision != null:
		ball.velocity = ball.velocity.bounce(collision.get_normal()) * Ball.BOUNCINESS
		ball.switch_state(Ball.State.FREEFORM)

func can_air_interact() -> bool:
	return false
