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

func _on_unit_died():
	queue_free()

func _ready():
	if (attack_component==null): #healer
		stats.action = 7
		stats.actionSpeed=1
	if (heal_component==null): #warrior
		stats.action=10
		stats.actionSpeed=1
	if(health_component!=null):
		health_component.unit_died.connect(_on_unit_died)
