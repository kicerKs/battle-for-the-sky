extends Node

signal config_loaded

signal music_volume_changed
signal sound_volume_changed
signal music_muted

signal player_info_changed(id)

signal building_clicked(building: Building)
signal unit_clicked(unit: TestCharacter)
signal monster_clicked(unit: TestMonster)
signal hide_panels
signal panels_closed
signal show_resource_cost(dict: Dictionary)
signal hide_resource_cost

signal player_eliminated(id)
signal player_won(id)

signal island_conquered(before, after)
signal resource_generated(res, amount)
signal resource_spent(res, amount)
signal building_built(side)
signal unit_trained(name, side)
signal unit_died(side)
signal unit_killed(side)
signal monster_killed(side)

signal zoom_changed(zoom)
