extends Node
class_name HealthComponent

var testCharacter: TestCharacter

var max_hp: int
var current_hp: int
var armor: int
var damage:int

signal unit_died
signal hp_changed(hp)

func take_damage(amount: int) -> void:
	damage = (100 - armor) * (amount)/100
	current_hp = max(current_hp-damage, 0)
	%HPBar.value = current_hp
	if (current_hp ==0):
		emit_signal("unit_died")
	
func  _ready() ->void:
	await owner.ready
	testCharacter = owner as TestCharacter
	max_hp = testCharacter.stats.max_hp
	current_hp = testCharacter.stats.max_hp
	armor = testCharacter.stats.armor
	%HPBar.max_value = max_hp
	%HPBar.value = current_hp
