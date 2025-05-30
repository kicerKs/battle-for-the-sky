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
	await tree_entered

# ownership of island where unit is standing
func get_current_island_ownership():
	var current_island_key = Game.tileMapLayer.local_to_map(unit.position)
	if Game.tileMapLayer.tiles.has(current_island_key):
		var current_island_side = Game.tileMapLayer.tiles[current_island_key].ownership
		return current_island_side
