extends Node
class_name State

signal change_state(next_state_path: String)

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass
