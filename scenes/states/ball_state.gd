class_name BallState
extends Node

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
