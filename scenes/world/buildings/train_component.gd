extends Node
class_name TrainComponent

@export var stats: TrainerStats

@export var search_component: SearchComponent

@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var label: Label = $"../Label"

var new_unit: CharacterBody2D
static var xd = 0

@export var training_progress: float

var is_active: bool = false
var island_key: Vector2i
var island_ownership: Lobby.Factions
var spawn_position: Vector2

var current_front: Vector2i:
	set(value):
		if current_front != value:
			current_front = value
			var units = get_tree().get_nodes_in_group("units") if get_tree() else []
			if not units.is_empty():
				for unit in units:
					if unit.spawn_position == spawn_position:
						unit.current_front = current_front

var _current_train_timer: float = 0.0
var _is_training: bool = false
var _training_loop: bool = false # For disabling unit training
var front_change_mode: bool = false:
	set(value):
		front_change_mode = value
		if value:
			label.text = "true"
		else:
			label.text = "false"

# This function is called only when building is placed on island
func activate():
	is_active = true
	spawn_position = get_parent().global_position
	change_front.rpc(search_component.find_nearest_enemy_island(
		Game.tileMapLayer.local_to_map(spawn_position)
	))
	#current_front = search_component.find_nearest_enemy_island(
	#	Game.tileMapLayer.local_to_map(spawn_position)
	#)
	_training_loop = true
	
	var line = owner.get_node("Buttons").get_node("Line2D")
	line.global_position = Vector2(0, 0)
	line.clear_points()
	line.add_point(owner.global_position)
	line.add_point(Game.tileMapLayer.map_to_local(current_front))

func load_unit():
	new_unit = stats.unit.instantiate()
	new_unit.name = "Unit"+str(xd)
	xd+=1
	new_unit.auto_front_change.connect(_on_auto_front_change)
	new_unit.side = island_ownership
	new_unit.spawn_position = spawn_position

# for testing 
func _unhandled_input(event: InputEvent) -> void:
	if front_change_mode:
		if event is InputEventMouse and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				change_front.rpc(Game.tileMapLayer.local_to_map(owner.get_global_mouse_position()))
				#current_front = Game.tileMapLayer.local_to_map(owner.get_global_mouse_position())

func _process(delta: float) -> void:
	%UnitTrainProgressBar.value = training_progress
	if multiplayer.is_server():
		if is_active:
			if _is_training:
				_current_train_timer -= delta
				if _current_train_timer <= 0:
					complete_training()
			if _training_loop:
				start_training()
			training_progress = get_training_progress()

func start_training():
	if multiplayer.is_server():
		if _is_training:
			return false
		
		var player_id
		for id in Lobby.players.keys():
			if Lobby.players[id]["color"] == island_ownership:
				player_id = id
		_is_training = true
		reduce_resource.rpc_id(player_id)

@rpc("any_peer", "call_local", "reliable")
func training_started():
	load_unit()
	hide_no_resources.rpc()
	hide_sleep.rpc()
	_current_train_timer = stats.training_time
	return true

@rpc("any_peer", "call_local", "reliable")
func reduce_resource():
	for res in stats.training_cost:
		if Game.get_player_resource(res) < stats.training_cost[res]:
			show_no_resources.rpc()
			return false
	for res in stats.training_cost:
		Game.change_player_resource(res, -stats.training_cost[res])
	training_started.rpc_id(1)

@rpc("any_peer", "call_local", "reliable")
func show_no_resources():
	%NoResources.visible = true

@rpc("any_peer", "call_local", "reliable")
func hide_no_resources():
	%NoResources.visible = false

@rpc("any_peer", "call_local", "reliable")
func show_sleep():
	%BuildingSleeps.visible = true

@rpc("any_peer", "call_local", "reliable")
func hide_sleep():
	%BuildingSleeps.visible = false

func complete_training(): 
	if multiplayer.is_server():
		_is_training = false
		new_unit.current_front = current_front
		new_unit.owner = get_tree().current_scene.get_node("World")
		get_tree().current_scene.get_node("World").add_child(new_unit)
		new_unit.global_position = spawn_position
		if _training_loop:
			start_training()

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / stats.training_time)

func _on_train_activate_button_pressed() -> void:
	change_training_status.rpc()

@rpc("any_peer", "call_local", "reliable")
func change_training_status():
	if multiplayer.is_server():
		if _training_loop:
			#%TrainActivateButton.text = "OFF"
			show_sleep.rpc()
		else:
			#%TrainActivateButton.text = "ON"
			hide_sleep.rpc()
		_training_loop = !_training_loop

func _on_front_change_button_pressed() -> void:
	front_change_mode = true

func _on_auto_front_change(island: Vector2i):
	change_front.rpc(search_component.find_nearest_enemy_island(island))
	#current_front = search_component.find_nearest_enemy_island(island)

@rpc("call_local", "any_peer", "reliable")
func change_front(pos):
	current_front = pos
	var line = owner.get_node("Buttons").get_node("Line2D")
	line.global_position = Vector2(0, 0)
	line.clear_points()
	line.add_point(owner.global_position)
	line.add_point(Game.tileMapLayer.map_to_local(current_front))


func _on_train_activate_button_mouse_entered() -> void:
	SignalBus.show_resource_cost.emit(stats.training_cost)

func _on_train_activate_button_mouse_exited() -> void:
	SignalBus.hide_resource_cost.emit()
