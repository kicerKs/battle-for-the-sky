extends Node2D
class_name MovementComponent

@export var speed := 150.0
@export var nav_agent: NavigationAgent2D
@export var anim: AnimatedSprite2D 

var target_position: Vector2 = Vector2.ZERO
var intended_velocity: Vector2 = Vector2.ZERO

func _input(event):
	
	if event.is_action_pressed("mouse_click"):
		target_position = get_global_mouse_position()
		nav_agent.target_position = target_position

func update_movement(delta):
	if nav_agent.is_navigation_finished():
		anim.play("idle")
		intended_velocity = Vector2.ZERO
		return
		
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	intended_velocity = direction * speed
	nav_agent.set_velocity(intended_velocity)

	anim.play("walk")
