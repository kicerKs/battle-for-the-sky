extends Node
class_name TrainComponent

@export var unit_scene: PackedScene

# These variables are in train units
@export var train_time: float = 10.0 # in seconds
@export var resource_cost: Dictionary = {
	Game.Resources.GOLD: 25,
	Game.Resources.FOOD: 50
}

var is_active: bool = false

var _current_train_timer: float = 0.0
var _is_training: bool = false
var _spawn_position: Vector2 = Vector2.ZERO
var _training_loop: bool = false

func activate():
	is_active = true
	_spawn_position = get_parent().global_position
	_training_loop = true

func _process(delta: float) -> void:
	if is_active:
		if _is_training:
			_current_train_timer -= delta
			%UnitTrainProgressBar.value = get_training_progress()
			if _current_train_timer <= 0:
				complete_training()
		if _training_loop:
			start_training()

func start_training():
	if _is_training:
		return false
	
	for res in resource_cost:
		if Game.get_player_resource(res) < resource_cost[res]:
			return false
	
	for res in resource_cost:
		Game.change_player_resource(res, -resource_cost[res])
	
	_is_training = true
	_current_train_timer = train_time
	return true

func complete_training(): 
	_is_training = false
	
	var new_unit = unit_scene.instantiate()
	get_tree().current_scene.add_child(new_unit)
	new_unit.global_position = _spawn_position
	
	if _training_loop:
		start_training()

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / train_time)

func _on_button_pressed() -> void:
	if _training_loop:
		%TrainActivateButton.text = "OFF"
	else:
		%TrainActivateButton.text = "ON"
	
	_training_loop = !_training_loop
