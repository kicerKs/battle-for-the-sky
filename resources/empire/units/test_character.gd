extends CharacterBody2D

@export var stats: UnitStats
@export var movement_component: MovementComponent

var target_position: Vector2 = Vector2.ZERO
var intended_velocity: Vector2 = Vector2.ZERO



func _ready():
	nav_agent.velocity_computed.connect(_on_navigation_agent_velocity_computed)

func _physics_process(delta):
	movement_component.update_movement(delta)
	move_and_slide()

func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
 
