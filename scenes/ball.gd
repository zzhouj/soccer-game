class_name Ball
extends AnimatableBody2D

enum State {CARRIED, FREEFORM, SHOT}

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_detection_area: Area2D = %PlayerDetectionArea

var carrier: Player = null
var current_state: BallState = null
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO

func _ready() -> void:
	switch_state(State.FREEFORM)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_state(state)
	current_state.setup(self, animation_player, player_detection_area, carrier)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallState: " + str(state)
	call_deferred("add_child", current_state)
