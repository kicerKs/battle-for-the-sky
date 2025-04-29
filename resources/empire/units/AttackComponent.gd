class_name AttackComponent
extends Node

@export var attack_speed:=1.0 # attacks per second

@export_group("Damage")
@export var melee_damage:= 10.0
@export var ranger_damage:=9.0
@export var aoe_damage:=4.0

@export_group("Range")
@export var melee_range:=1.0
@export var ranger_range:=10.0
@export var aoe_range:= 5.0

func deal_melee_damage(target: HealthComponent) -> void:
	target.take_damage(melee_damage)

func deal_ranged_damage(target: HealthComponent) -> void:
	target.take_damage(ranger_damage)

func deal_aoe_damage(targets: Array) -> void:
	for target in targets:
		if target is HealthComponent:
			target.take_damage(aoe_damage)
