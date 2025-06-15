class_name PlayerStateVolleyKick
extends PlayerState

const BONUS_POWER := 1.5
const BALL_HEIGHT_MIN := 1.0
const BALL_HEIGHT_MAX := 20.0

func _enter_tree() -> void:
	animation_player.play("volley_kick")
	ball_detection_area.body_entered.connect(on_ball_entered.bind())

func on_ball_entered(ctx_ball: Ball) -> void:
	if ctx_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		var distination := target_goal.get_random_target_position()
		var direction := ball.position.direction_to(distination)
		ctx_ball.shoot(direction * player.power * BONUS_POWER)

func on_animation_complete() -> void:
	transition_state(Player.State.RECOVERING)
