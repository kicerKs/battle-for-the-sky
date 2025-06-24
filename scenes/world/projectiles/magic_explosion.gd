extends Area2D
class_name MagicExplosion

var source

func setup(s, target):
	position = Vector2(0, 0)
	global_position = target
	source = s

func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		for target in get_overlapping_bodies():
			if target is TestMonster:
				source.attack_component.deal_damage(target)
			elif target is TestCharacter:
				if target.side != source.side:
					source.attack_component.deal_damage(target)
		remove.rpc()

@rpc("call_local", "any_peer", "reliable")\
func remove():
	queue_free()
