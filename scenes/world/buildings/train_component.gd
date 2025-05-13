extends Node
class_name TrainComponent

@export var base_unit_scene: PackedScene
@export var upgraded_unit_scene: PackedScene

@export var texture1: CompressedTexture2D
@export var texture2: CompressedTexture2D

@onready var sprite: Sprite2D = $"../Sprite2D"

var new_unit: CharacterBody2D
var unit_stats: UnitStats

var is_active: bool = false
var building_level: int = 0

var _current_train_timer: float = 0.0
var _is_training: bool = false
var _spawn_position: Vector2 = Vector2.ZERO 
var _training_loop: bool = false # For disabling unit training

func _ready() -> void:
	sprite.texture = texture1

# This function is called only when building is placed on island
func activate():
	is_active = true
	_spawn_position = get_parent().global_position
	_training_loop = true

func load_unit():
	match building_level:
		0:
			new_unit = base_unit_scene.instantiate()
		1:
			new_unit = upgraded_unit_scene.instantiate()
	unit_stats = new_unit.stats

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
	
	load_unit()
	for res in unit_stats.trainingResources:
		if Game.get_player_resource(res) < unit_stats.trainingResources[res]:
			return false
	for res in unit_stats.trainingResources:
		Game.change_player_resource(res, -unit_stats.trainingResources[res])
	
	_is_training = true
	_current_train_timer = unit_stats.trainingTime
	return true

func complete_training(): 
	_is_training = false
	get_tree().current_scene.add_child(new_unit)
	new_unit.global_position = _spawn_position
	if _training_loop:
		start_training()

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / unit_stats.trainingTime)

func _on_train_activate_button_pressed() -> void:
	if _training_loop:
		%TrainActivateButton.text = "OFF"
	else:
		%TrainActivateButton.text = "ON"
	
	_training_loop = !_training_loop

func _on_upgrade_button_pressed() -> void:
	building_level += 1
	%UpgradeButton.disabled = true
	sprite.texture = texture2
