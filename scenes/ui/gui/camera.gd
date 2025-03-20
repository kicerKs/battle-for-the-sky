extends Camera2D

@export var SPEED: float = 1000.0
@export var camera_limit_start: Vector2 = Vector2(0, 0)
@export var camera_limit_end: Vector2 = Vector2(1152, 648)

func _process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	position += direction.normalized() * SPEED * delta
	position = position.clamp(camera_limit_start, camera_limit_end)
