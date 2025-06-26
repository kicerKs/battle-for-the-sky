extends Node2D

func _enter_tree() -> void:
	$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
