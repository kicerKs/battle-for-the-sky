extends Node
class_name MovementComponent

@export var testCharacter: TestCharacter
@export var speed: int = 100

var target_position: Vector2 = Vector2.ZERO
var intended_velocity: Vector2 = Vector2.ZERO

func _ready():
	await owner.ready
	owner.nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	testCharacter = owner as TestCharacter
	speed = testCharacter.stats.speed

func start_moving():
	target_position = owner.get_global_mouse_position()
	owner.nav_agent.target_position = target_position

func update_movement(delta):
	var next_path_pos: Vector2 = owner.nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - owner.global_position).normalized()
	intended_velocity = direction * speed
	owner.nav_agent.set_velocity(intended_velocity)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	owner.velocity = safe_velocity
