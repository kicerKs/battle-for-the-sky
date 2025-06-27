extends Area2D
class_name MagicMissileProjectile

var source: CharacterBody2D
var target: CharacterBody2D

var direction
var end_position
var off

@export var speed = 550
@export var g_pos = global_position

var explosion_scene = load("res://scenes/world/projectiles/magic_explosion.tscn")
static var i = 0

func setup(s, t):
	source = s
	target = t
	global_position = source.global_position
	off = Vector2(randi_range(-75, 75), randi_range(-75, 75))
	end_position = target.global_position + off

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if target != null:
			direction = global_position.direction_to(target.global_position + off)
			end_position = target.global_position + off
			global_position += direction * speed * delta
		elif direction == null:
			queue_free()
			return
		else:
			global_position += direction * speed * delta
		g_pos = global_position
		$Sprite2D.look_at(end_position)
		if global_position.distance_to(end_position) < 10:
			var explosion = explosion_scene.instantiate()
			explosion.setup(source, self.global_position)
			explosion.name = "MagicExplosion" + str(i)
			i+=1
			Game.world.add_child(explosion)
			remove.rpc()
	else:
		global_position = g_pos

@rpc("any_peer", "call_local", "reliable")
func remove():
	queue_free()
