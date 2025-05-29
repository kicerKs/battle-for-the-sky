extends Node
class_name TrainComponent

@export var base_unit: UnitStats
@export var upgraded_unit: UnitStats

@export var texture1: CompressedTexture2D
@export var texture2: CompressedTexture2D

@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var unit_scene = load("res://scenes/world/units/test_character.tscn")

@onready var label: Label = $"../Label"

var new_unit: CharacterBody2D
var islands_map

var is_active: bool = false
var building_level: int = 0
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

func _ready() -> void:
	sprite.texture = texture1
	islands_map = get_tree().get_first_node_in_group("islands_map")

# This function is called only when building is placed on island
func activate():
	is_active = true
	spawn_position = get_parent().global_position
	_training_loop = true

func load_unit():
	new_unit = unit_scene.instantiate()
	new_unit.side = island_ownership
	new_unit.spawn_position = spawn_position
	match building_level:
		0:
			new_unit.stats = base_unit
		1:
			new_unit.stats = upgraded_unit

# for testing 
func _unhandled_input(event: InputEvent) -> void:
	if front_change_mode:
		if event is InputEventMouse and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				current_front = islands_map.local_to_map(owner.get_global_mouse_position())
			front_change_mode = false

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
	for res in new_unit.stats.trainingResources:
		if Game.get_player_resource(res) < new_unit.stats.trainingResources[res]:
			return false
	for res in new_unit.stats.trainingResources:
		Game.change_player_resource(res, -new_unit.stats.trainingResources[res])
	
	_is_training = true
	_current_train_timer = new_unit.stats.trainingTime
	return true

func complete_training(): 
	_is_training = false
	new_unit.current_front = current_front
	get_tree().current_scene.add_child(new_unit)
	new_unit.global_position = spawn_position
	if _training_loop:
		start_training()

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / new_unit.stats.trainingTime)

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

func _on_front_change_button_pressed() -> void:
	front_change_mode = true
