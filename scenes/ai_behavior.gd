class_name AIBehavior
extends Node

const DURATION_AI_TICK := 200

var player: Player = null
var ball: Ball = null
var time_since_last_tick := Time.get_ticks_msec()

func setup(ctx_player: Player, ctx_ball: Ball) -> void:
	player = ctx_player
	ball = ctx_ball

func _ready() -> void:
	time_since_last_tick = Time.get_ticks_msec() + randi_range(0, DURATION_AI_TICK)

func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_tick > DURATION_AI_TICK:
		time_since_last_tick = Time.get_ticks_msec()
		perform_ai_movement()
		perform_ai_decisions()

func perform_ai_movement() -> void:
	var total_steering_force := player.weight_on_duty * player.position.direction_to(ball.position)
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed

func perform_ai_decisions() -> void:
	pass
