class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL}
enum Role {GOALIE, DEFENSE, MIDFIELD, OFFENSE}
enum SkinColor {LIGHT, MEDIUM, DARK}

const CONTROL_SCHEME_MAP: Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}
const GRAVITY := 8.0
const BALL_CONTROL_HEIGHT_MAX := 10.0

@export var control_scheme: ControlScheme
@export var speed: float
@export var power: float
@export var ball: Ball
@export var own_goal: Goal
@export var target_goal: Goal


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_sprite: Sprite2D = %PlayerSprite
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var teammate_detection_area: Area2D = %TeammateDetectionArea
@onready var ball_detection_area: Area2D = %BallDetectionArea

var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var fullname := ""
var skin_color := SkinColor.LIGHT
var role := Role.MIDFIELD

func initialize(ctx_position: Vector2, ctx_ball: Ball, ctx_own_goal: Goal, ctx_target_goal: Goal, ctx_player_data: PlayerResource) -> void:
	position = ctx_position
	ball = ctx_ball
	own_goal = ctx_own_goal
	target_goal = ctx_target_goal
	fullname = ctx_player_data.full_name
	skin_color = ctx_player_data.skin_color
	role = ctx_player_data.role
	speed = ctx_player_data.speed
	power = ctx_player_data.power
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT

func _ready() -> void:
	set_control_texture()
	switch_state(State.MOVING)

func _physics_process(delta: float) -> void:
	flip_sprites()
	set_control_visibility()
	process_gravity(delta)
	move_and_slide()

func switch_state(state: State, state_data := PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_state(state)
	current_state.setup(self, ball, own_goal, target_goal, animation_player, teammate_detection_area, ball_detection_area, state_data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerState: " + str(state)
	call_deferred("add_child", current_state)

func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT

func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true

func has_ball() -> bool:
	return ball.carrier == self

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func set_control_visibility() -> void:
	control_sprite.visible = has_ball() or control_scheme != ControlScheme.CPU

func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height <= 0:
			height = 0
	player_sprite.position = Vector2.UP * height

func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT_MAX:
		switch_state(State.CHEST_CONTROL)
