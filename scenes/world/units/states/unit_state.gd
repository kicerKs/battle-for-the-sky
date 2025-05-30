extends State
class_name UnitState

const IDLE = "Idle"
const MOVING = "Moving"
const CONQUERING = "Conquering"
const ATTACKING = "Attacking"

var state_machine: StateMachine
var unit: TestCharacter

func _ready() -> void:
	await owner.ready
	unit = owner as TestCharacter
	state_machine = get_tree().get_first_node_in_group("state_machine")
