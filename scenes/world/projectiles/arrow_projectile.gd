extends Area2D
class_name ArrowProjectile

var source: CharacterBody2D
var target: CharacterBody2D

@export var speed = 350
@export var g_pos = global_position

var direction
var end_position

func setup(s, t):
	source = s
	target = t
	
	global_position = source.global_position

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if target != null:
			direction = global_position.direction_to(target.global_position)
			end_position = target.global_position
		elif direction == null:
			queue_free()
		global_position += direction * speed * delta
		g_pos = global_position
		$Sprite2D.look_at(end_position)
		if global_position.distance_to(end_position) < 100 and target == null:
			queue_free()
	else:
		global_position = g_pos

func _on_body_entered(body: Node) -> void:
	if body == target and multiplayer.is_server():
		source.attack_component.deal_damage(target)
		remove.rpc()

@rpc("any_peer", "call_local", "reliable")
func remove():
	queue_free()
