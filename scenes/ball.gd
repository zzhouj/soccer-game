class_name Ball
extends AnimatableBody2D

const BOUNCINESS := 0.8
const DISTANCE_HIGH_PASS = 130.0

enum State {CARRIED, FREEFORM, SHOT}

@export var friction_air: float
@export var friction_ground: float
@export var air_connect_min_height: float
@export var air_connect_max_height: float

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_detection_area: Area2D = %PlayerDetectionArea
@onready var ball_sprite: Sprite2D = %BallSprite

var carrier: Player = null
var current_state: BallState = null
var state_factory := BallStateFactory.new()
var velocity := Vector2.ZERO
var height := 0.0
var height_velocity := 0.0

func _ready() -> void:
	switch_state(State.FREEFORM)

func _physics_process(delta: float) -> void:
	ball_sprite.position = Vector2.UP * height

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_state(state)
	current_state.setup(self, animation_player, player_detection_area, ball_sprite, carrier)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallState: " + str(state)
	call_deferred("add_child", current_state)

func shoot(shot_velocity: Vector2) -> void:
	velocity = shot_velocity
	carrier = null
	switch_state(State.SHOT)

func pass_to(target: Vector2) -> void:
	var direction = position.direction_to(target)
	var distance = position.distance_to(target)
	var intensity = sqrt(2 * friction_ground * distance)
	velocity = direction * intensity
	if distance > DISTANCE_HIGH_PASS:
		height_velocity = BallState.GRAVITY * distance / (1.8 * intensity)
	carrier = null
	switch_state(State.FREEFORM)

func stop() -> void:
	velocity = Vector2.ZERO

func can_air_interact() -> bool:
	return current_state != null and current_state.can_air_interact()

func can_air_connect() -> bool:
	return height > air_connect_min_height and height < air_connect_max_height
