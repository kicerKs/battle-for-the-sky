extends Camera2D

@export var moving_speed: float = 1000.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.25
@export var max_zoom: float = 2.0
@export var edge_scroll_speed: float = 1000.0
@export var edge_scroll_margin: int = 20

var camera_limit_start: Vector2i
var camera_limit_end: Vector2i

func _ready():
	Game.camera = self
	var rect = $"../TileMapLayer".get_used_rect()
	var tile_size = $"../TileMapLayer".tile_set.tile_size
	camera_limit_end.x = tile_size.x + ((rect.size.x-1) * tile_size.x) 
	camera_limit_end.y = (tile_size.y/2) + ((rect.size.y-1)) * (tile_size.y*0.75)
	camera_limit_start.x = -(tile_size.x/4)
	camera_limit_start.y = -tile_size.y/4
	if Game.tileMapLayer.starting_islands.has(Lobby.player_info["color"]):
		setup_camera()

func setup_camera():
	position = Vector2(Game.tileMapLayer.map_to_local(Game.tileMapLayer.starting_islands[Lobby.player_info["color"]]))
	zoom = Vector2(0.5, 0.5)

func reset_camera():
	var rect = $"../TileMapLayer".get_used_rect()
	var tile_size = $"../TileMapLayer".tile_set.tile_size
	camera_limit_end.x = tile_size.x + ((rect.size.x-1) * tile_size.x) 
	camera_limit_end.y = (tile_size.y/2) + ((rect.size.y-1)) * (tile_size.y*0.75)
	camera_limit_start.x = -(tile_size.x/4)
	camera_limit_start.y = -tile_size.y/4

func _process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	# WSAD / Arrow Key Movement
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	# Edge Scrolling
	
	#var mouse_pos = get_viewport().get_mouse_position()
	#var screen_size = get_viewport_rect().size
	
	#if mouse_pos.x <= edge_scroll_margin:
	#	direction.x -= 1
	#elif mouse_pos.x >= screen_size.x - edge_scroll_margin:
	#	direction.x += 1
	#if mouse_pos.y <= edge_scroll_margin:
	#	direction.y -= 1
	#elif mouse_pos.y >= screen_size.y - edge_scroll_margin:
	#	direction.y += 1
	
	# Changing camera position
	if direction != Vector2.ZERO:
		# Camera speed is also adjusted to zoom value
		position += direction.normalized() * moving_speed * (1 / zoom.x) * delta
	position = position.clamp(camera_limit_start, camera_limit_end)

func _input(event):
	# Zooming
	if Input.is_action_just_pressed("zoom_in"):
		zoom *= Vector2(1 + zoom_speed, 1 + zoom_speed)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom *= Vector2(1 - zoom_speed, 1 - zoom_speed)
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	SignalBus.zoom_changed.emit(zoom)
