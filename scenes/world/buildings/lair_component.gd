extends Node
class_name LairComponent

@export var stats: LairStats

@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var label: Label = $"../Label"

var new_unit: CharacterBody2D
static var xd = 0

@export var training_progress: float
var active_monsters = 0

var is_active: bool = false
var island_key: Vector2i
var island_ownership: Lobby.Factions
var spawn_position: Vector2

var _current_train_timer: float = 0.0
var _is_training: bool = false
var _training_loop: bool = false # For disabling unit training

# This function is called only when building is placed on island
func activate():
	is_active = true
	spawn_position = get_parent().global_position
	_training_loop = true

func load_unit():
	new_unit = stats.unit.instantiate()
	new_unit.name = "Monster"+str(xd)
	xd+=1
	new_unit.side = island_ownership

func _process(delta: float) -> void:
	#%UnitTrainProgressBar.value = training_progress
	if is_active:
		if _is_training:
			_current_train_timer -= delta
			if _current_train_timer <= 0:
				complete_training()
		if _training_loop:
			start_training()
		training_progress = get_training_progress()

func start_training():
	if _is_training or active_monsters >= stats.unit_limit:
		return false
	
	load_unit()
	
	_is_training = true
	_current_train_timer = stats.training_time
	return true

func complete_training(): 
	_is_training = false
	new_unit.owner = get_tree().current_scene.get_node("World")
	get_tree().current_scene.get_node("World").add_child(new_unit)
	new_unit.global_position = spawn_position
	new_unit.connect("monster_died", monster_died)
	active_monsters+=1
	if _training_loop:
		start_training()

func monster_died():
	active_monsters -= 1

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / stats.training_time)

func _on_train_activate_button_pressed() -> void:
	#if _training_loop:
	#	%TrainActivateButton.text = "OFF"
	#else:
	#	%TrainActivateButton.text = "ON"
	
	_training_loop = !_training_loop
