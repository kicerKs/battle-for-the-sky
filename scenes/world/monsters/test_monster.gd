class_name TestMonster
extends CharacterBody2D

@export var stats: MonsterStats

@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var heal_component: HealComponent

var side : Lobby.Factions = Lobby.Factions.MONSTERS
@export var animation: AnimatedSprite2D
@export var nav_agent: NavigationAgent2D

@onready var label = $Label

func _on_unit_died():
	die.rpc()

@rpc("authority", "call_local", "reliable")
func die():
	queue_free()

func _ready():
	# normalnie podpinasz se png unitow jakie chcesz i animacje same sie tworza
	var spritesheet = stats.spriteSheet
	animation.setup_animations(spritesheet)
	
	
	if (attack_component==null): #healer
		stats.action = 7
		stats.actionSpeed=1
	if (heal_component==null): #warrior
		stats.action=10
		stats.actionSpeed=1
	if(health_component!=null):
		health_component.unit_died.connect(_on_unit_died)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.monster_clicked.emit(self)
