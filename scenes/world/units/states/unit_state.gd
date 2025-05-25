extends State
class_name UnitState

const IDLE = "Idle"
const MOVING = "Moving"
const CONQUERING = "Conquering"
const ATTACKING = "Attacking"

var state_machine: StateMachine
var unit: TestCharacter
var islands_map

func _ready() -> void:
	await owner.ready
	unit = owner as TestCharacter
	islands_map = get_tree().get_first_node_in_group("islands_map")
	state_machine = get_tree().get_first_node_in_group("state_machine")

func get_island_ownership(key: Vector2i) -> Lobby.Factions:
	return islands_map.tiles[key].ownership
