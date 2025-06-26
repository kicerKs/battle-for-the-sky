extends Node
class_name MovementComponent

@export var testCharacter: CharacterBody2D
@export var speed: int = 100

@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"

var collisions: Array[Vector2] = []
var target_position: Vector2 = Vector2.ZERO
var intended_velocity: Vector2 = Vector2.ZERO

func _ready():
	await owner.ready
	owner.nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	speed = owner.stats.speed

func start_moving(target_island_pos: Vector2):
	owner.nav_agent.target_position = target_island_pos

func end_moving():
	var nav: NavigationAgent2D = owner.nav_agent
	nav.target_position = owner.global_position

func add_collision(vector: Vector2):
	collisions.append(vector)

func update_movement(delta):
	var next_path_pos: Vector2 = owner.nav_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - owner.global_position).normalized()
	if owner.get_node("StateMachine").state != owner.get_node("StateMachine").get_node("Attacking"):
		if direction.x > 0:
			animation.flip_h = false
		else:
			animation.flip_h = true
	intended_velocity = direction * speed
	for coll in collisions:
		intended_velocity += coll
	collisions.clear()
	owner.nav_agent.set_velocity(intended_velocity)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	owner.velocity = safe_velocity

func set_velocity(velocity: Vector2) -> void:
	owner.nav_agent.set_velocity(velocity)

func get_velocity() -> Vector2:
	return owner.velocity
