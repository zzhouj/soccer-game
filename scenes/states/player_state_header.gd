class_name PlayerStateHeader
extends PlayerState

const HEIGHT_START := 0.1
const HEIGHT_VELOCITY := 1.5
const BONUS_POWER := 1.3

func _enter_tree() -> void:
	animation_player.play("header")
	player.height = HEIGHT_START
	player.height_velocity = HEIGHT_VELOCITY
	ball_detection_area.body_entered.connect(on_ball_entered.bind())

func on_ball_entered(ctx_ball: Ball) -> void:
	if ctx_ball.can_air_connect():
		ctx_ball.shoot(player.velocity.normalized() * player.power * BONUS_POWER)

func _process(delta: float) -> void:
	if player.height == 0:
		transition_state(Player.State.RECOVERING)
