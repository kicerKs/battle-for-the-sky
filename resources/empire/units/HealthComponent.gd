extends Resource
class_name HealthComponent

@export var max_hp:= 100.0
@export var current_hp:=100.0
@export var hp_regen:=7.0 #per second?
@export var armor :=10.0

func heal(delta: float) -> void:
	current_hp = min(current_hp + hp_regen * delta, max_hp)

func take_damage(amount: float) -> void:
	current_hp = max(current_hp - amount, 0)
	if (current_hp ==0):
		emit_signal("died")
	
