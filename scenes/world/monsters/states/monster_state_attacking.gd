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
	var array = %AttackRange.get_overlapping_bodies()
	if owner.attack_component.target == null or owner.attack_component.target not in array:
		change_state.emit(ENGAGE)
	
