extends MonsterState

@onready var attack_speed = owner.stats.actionSpeed
var timer = attack_speed

func on_enter() -> void:
	print("Start attacking")
	monster.label.text = "Attacking"
	monster.animation.play("attack")
	timer = attack_speed

func update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = attack_speed
		if owner.attack_component.target != null:
			owner.attack_component.damage()
	if owner.attack_component.target == null:
		change_state.emit(ENGAGE)
