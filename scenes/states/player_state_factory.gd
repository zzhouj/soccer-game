class_name PlayerStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.PREPPING_SHOT: PlayerStatePreppingShot,
		Player.State.SHOOTING: PlayerStateShooting,
		Player.State.PASSING: PlayerStatePassing,
		Player.State.HEADER: PlayerStateHeader,
		Player.State.VOLLEY_KICK: PlayerStateVolleyKick,
		Player.State.BICYCLE_KICK: PlayerStateBicycleKick,
		Player.State.CHEST_CONTROL: PlayerStateChestControl,
	}

func get_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "state does not exist!")
	return states.get(state).new()
