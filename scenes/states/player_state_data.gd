class_name PlayerStateData

var shot_power: float
var shot_direction: Vector2

static func build() -> PlayerStateData:
	return PlayerStateData.new()

func set_shot_power(ctx_shot_power: float) -> PlayerStateData:
	shot_power = ctx_shot_power
	return self

func set_shot_direction(ctx_shot_direction: Vector2) -> PlayerStateData:
	shot_direction = ctx_shot_direction
	return self
