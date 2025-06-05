class_name AttackComponent
extends Node

var target: CharacterBody2D

var testCharacter: TestCharacter
var attack_speed:int
var attack:int
var range:int
var singleTarget:bool



func _ready() ->void:
	await owner.ready
	testCharacter = owner as TestCharacter
	attack_speed= testCharacter.stats.actionSpeed
	attack = testCharacter.stats.action
	range = testCharacter.stats.range
	singleTarget = testCharacter.stats.singleTarget

func damage()->void: #funkcja będzie wywoływana dla listy przeciwników którzy się znajdują w range unit
	if singleTarget:
		target.health_component.take_damage(attack)
	# To dla AOE do pokombinowania potem
	else:
		var targets
		for target in targets:
			if target is HealthComponent:
				target.take_damage(attack) #Do zrobienia: wybierz przeciwnika najbliższego  - posortuj po odległości?
				if (singleTarget):break
			
