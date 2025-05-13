extends Node
class_name MovementComponent

@export var testCharacter: TestCharacter
@export var nav_agent: NavigationAgent2D   
@export var anim: AnimatedSprite2D
@export var speed: int = 100

var target_position: Vector2 = Vector2.ZERO
var intended_velocity: Vector2 = Vector2.ZERO

func _ready():
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	await owner.ready
	testCharacter = owner as TestCharacter
	speed = testCharacter.stats.speed

func _input(event):
	if event.is_action_pressed("mouse_click"):
		target_position = owner.get_global_mouse_position()
		nav_agent.target_position = target_position

func update_movement(delta):
	if nav_agent.is_navigation_finished():
		anim.play("idle")
		intended_velocity = Vector2.ZERO
		return
		
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - owner.global_position).normalized()
	intended_velocity = direction * speed
	nav_agent.set_velocity(intended_velocity)

	anim.play("walk")

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	owner.velocity = safe_velocity
