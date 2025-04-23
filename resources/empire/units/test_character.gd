extends CharacterBody2D

@export var speed: float = 150.0
var target_position: Vector2 = Vector2.ZERO

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _input(event):
	if event.is_action_pressed("mouse_click"):
		target_position = get_global_mouse_position()
		nav_agent.target_position = target_position

func _physics_process(delta):
	# pathfinding
	if nav_agent.is_navigation_finished():
		anim.play("idle")
		return
	
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	var intended_velocity = direction * speed
	nav_agent.set_velocity(intended_velocity)
	
	anim.play("walk")

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
