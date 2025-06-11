class_name BallStateFreeform
extends BallState


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_body_entered.bind())

func on_body_entered(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)
