extends CharacterBody2D

@export var speed: float = 150.0
var target_position: Vector2 = Vector2.ZERO

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _input(event):
	if event.is_action_pressed("mouse_click"):
		target_position = get_global_mouse_position()
		nav_agent.target_position = target_position

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()
