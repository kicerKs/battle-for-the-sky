extends Node
class_name HealthComponent

@export var max_hp:= 100
@export var current_hp:=100
@export var armor :=10
var damage:int

signal unit_died

func take_damage(amount: int) -> void:
	damage = (100 - armor) * (amount)/100
	current_hp = max(current_hp-damage, 0)
	if (current_hp ==0):
		emit_signal("died")
	
