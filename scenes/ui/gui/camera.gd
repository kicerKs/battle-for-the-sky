extends Camera2D

@export var SPEED: float = 1000.0
var camera_limit_start: Vector2i
var camera_limit_end: Vector2i

func _ready():
	var rect = $"../TileMapLayer".get_used_rect()
	var tile_size = $"../TileMapLayer".tile_set.tile_size
	camera_limit_end.x = tile_size.x + ((rect.size.x-1) * tile_size.x) 
	camera_limit_end.y = (tile_size.y/2) + ((rect.size.y-1)) * (tile_size.y*0.75)
	camera_limit_start.x = (tile_size.x/2)
	camera_limit_start.y = tile_size.y/2

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
