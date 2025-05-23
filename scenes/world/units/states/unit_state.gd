extends State
class_name UnitState

const IDLE = "Idle"
const MOVING = "Moving"

var unit: TestCharacter

func _ready() -> void:
	await owner.ready
	unit = owner as TestCharacter
