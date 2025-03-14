extends Node
class_name StateMachine

@export var initial_state: State

var prevous_state_name: String
@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
	).call()
	
func _ready() -> void:
	for state_nodde: State in find_children("*", "State"):
		state_nodde.change_state.connect(transition_to_state)
		
	await owner.ready
	state.on_enter()

func _process(delta: float) -> void:
	state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to_state(target_state_path: String) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to change state to " + target_state_path + " but it does not exist.")
		return
	
	state.on_exit()
	prevous_state_name = state.name
	state = get_node(target_state_path)
	state.on_enter()
