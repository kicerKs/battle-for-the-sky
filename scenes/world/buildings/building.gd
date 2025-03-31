extends Node2D

@export var placement_mode: bool = true

func _input(_event: InputEvent):
	if placement_mode:
		position = get_global_mouse_position()
		if Input.is_action_just_pressed("mouse_click"):
			if $Area2D.has_overlapping_areas():
				print("I OVERLAP")
			else:
				print("I DO NOT OVERLAP")
				
