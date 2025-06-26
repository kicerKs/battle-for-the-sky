extends Node

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
