class_name HealComponent
extends Node

var testCharacter: TestCharacter

var target

var heal_am:int
var healSpeed:int

var heal_aura_scene = load("res://scenes/world/projectiles/heal_aura.tscn")

func _ready() -> void:
	await owner.ready
	testCharacter = owner as TestCharacter
	heal_am = testCharacter.stats.action
	healSpeed = testCharacter.stats.actionSpeed

func heal(): #wybrany najbliższy sojusznik
	target.health_component.heal(heal_am)
	target.add_child(heal_aura_scene.instantiate())
