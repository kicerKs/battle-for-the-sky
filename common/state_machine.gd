extends Node
class_name StateMachine

@export var initial_state: State

var previous_state_name: String
@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
	).call()
	
func _ready() -> void:
	for state_nodde: State in find_children("*", "State"):
		state_nodde.change_state.connect(transition_to_state)
		
	await owner.ready
	state.on_enter()

func _process(delta: float) -> void:
	if multiplayer.is_server():
		state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		state.physics_update(delta)

@rpc("any_peer", "call_remote", "reliable")
func transition_to_state(target_state_path: String) -> void:
	if multiplayer.is_server():
		transition_to_state.rpc(target_state_path)
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to change state to " + target_state_path + " but it does not exist.")
		return
	
	state.on_exit()
	previous_state_name = state.name
	state = get_node(target_state_path)
	state.on_enter()
