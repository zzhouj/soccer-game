class_name PlayerStateRecovering
extends PlayerState

const DURATION_RECOVER := 500

var time_start_recover := Time.get_ticks_msec()

func _enter_tree() -> void:
	animation_player.play("recover")
	time_start_recover = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recover > DURATION_RECOVER:
		transition_state(Player.State.MOVING)
