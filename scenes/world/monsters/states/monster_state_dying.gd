extends MonsterState

func on_enter() -> void:
	monster.label.text = "Dying"
	monster.animation.play("death")

func update(delta: float) -> void:
	if !monster.animation.is_playing():
		owner.die.rpc()
