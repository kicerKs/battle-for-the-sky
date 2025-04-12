extends Node2D
class_name Building

var placement_mode: bool = false

func _input(_event: InputEvent):
	if placement_mode:
		position = get_global_mouse_position()	

func can_build():
	if $Area2D.has_overlapping_areas():
		return false
	return true
