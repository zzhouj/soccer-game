class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}

@export var control_scheme: ControlScheme
@export var speed: float

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _process(_delta: float) -> void:
	if control_scheme ==ControlScheme.CPU:
		pass
	else:
		handle_player_movement()
	set_movement_animation()
	move_and_slide()


func handle_player_movement() -> void:
	var direction = KeyUtils.get_input_vector(control_scheme)
	velocity = direction * speed


func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")
