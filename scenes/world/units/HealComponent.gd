class_name HealComponent
extends Node

var testCharacter: TestCharacter

var heal:int
var healSpeed:int

func _ready() -> void:
	await owner.ready
	testCharacter = owner as TestCharacter
	heal = testCharacter.stats.action
	healSpeed = testCharacter.stats.actionSpeed

func Heal(target: HealthComponent): #wybrany najbliższy sojusznik
	target.current_hp+=heal 
