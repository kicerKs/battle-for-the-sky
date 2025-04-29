extends CharacterBody2D

@export var stats: UnitStats
@export var movement_component: MovementComponent

func _physics_process(delta):
	movement_component.update_movement(delta)
	move_and_slide()
