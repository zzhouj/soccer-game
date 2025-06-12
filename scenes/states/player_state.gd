class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, new_state_data: PlayerStateData)

var player: Player = null
var ball: Ball = null
var animation_player: AnimationPlayer = null
var state_data := PlayerStateData.new()

func setup(ctx_player: Player, ctx_ball: Ball, ctx_animation_player, ctx_state_data: PlayerStateData) -> void:
	player = ctx_player
	ball = ctx_ball
	animation_player = ctx_animation_player
	state_data = ctx_state_data

func transition_state(new_state: Player.State, new_state_data := PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, new_state_data)

func on_animation_complete() -> void:
	pass
