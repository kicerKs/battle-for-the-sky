class_name TestCharacter
extends CharacterBody2D

@export var stats: UnitStats

@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var heal_component: HealComponent

@export var side : Lobby.Factions
@export var animation: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D

@onready var label = $Label

signal auto_front_change(island: Vector2i)
signal front_changed(island: Vector2i)

var spawn_position: Vector2
var current_front: Vector2i:
	set(value):
		if current_front != value:
			current_front = value
			front_changed.emit(value)

func _on_unit_died():
	$StateMachine.transition_to_state(MonsterState.DYING)
	#die.rpc()

@rpc("authority", "call_local", "reliable")
func die():
	SignalBus.unit_died.emit(side)
	queue_free()

func _ready():
	# normalnie podpinasz se png unitow jakie chcesz i animacje same sie tworza
	var spritesheet: Texture2D
	match side:
		0: # monsters (won't be able to build on monster islands in the future)
			spritesheet = stats.spriteSheetBlue
		1: # other player
			spritesheet = stats.spriteSheetRed
		2: # our player
			spritesheet = stats.spriteSheetBlue
		3:
			spritesheet = stats.spriteSheetPurple
		4:
			spritesheet = stats.spriteSheetGreen
	animation.setup_animations(spritesheet)
	%AttackRangeCollisionShape2D.shape.radius = stats.range
	SignalBus.unit_trained.emit(stats.name, side)
	if(health_component!=null):
		health_component.unit_died.connect(_on_unit_died)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.unit_clicked.emit(self)
