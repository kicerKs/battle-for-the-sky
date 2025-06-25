class_name AttackComponent
extends Node

var target: CharacterBody2D

var testCharacter: TestCharacter
var attack_speed:int
var attack:int
var range:int
var singleTarget:bool

@export var projectile_scene = load("res://scenes/world/projectiles/arrow_projectile.tscn")
static var i = 0

func _ready() -> void:
	await owner.ready
	attack_speed= owner.stats.actionSpeed
	attack = owner.stats.action
	range = owner.stats.range
	singleTarget = owner.stats.singleTarget

func damage() -> void: #funkcja będzie wywoływana dla listy przeciwników którzy się znajdują w range unit
	if target.global_position.x < owner.global_position.x:
		owner.animation.flip_h = true
	else:
		owner.animation.flip_h = false
	if singleTarget and range <= 100:
		deal_damage(target)
	elif singleTarget and range > 100:
		var projectile = projectile_scene.instantiate()
		projectile.setup(owner, target)
		projectile.name = "Projectile"+str(i)
		i+=1
		add_child(projectile)
	# To dla AOE do pokombinowania potem
	else:
		var targets
		for target in targets:
			if target is HealthComponent:
				target.take_damage(attack) #Do zrobienia: wybierz przeciwnika najbliższego  - posortuj po odległości?
				if (singleTarget):break
			
func deal_damage(tar):
	tar.health_component.take_damage(attack)
