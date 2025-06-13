extends CanvasLayer

signal building_selected(building)

func _ready() -> void:
	var window_width = get_viewport().size.x
	var char_panel = get_node("characterPanel")
	var build_panel = get_node("BuildingPanel")
	#char_panel.custom_minimum_size = Vector2(window_width /2.2,0)
	#build_panel.custom_minimum_size = Vector2(window_width / 2.2,0)
	# test it out whether its a good idea	
	
	SignalBus.connect("building_clicked", show_building_panel)
	SignalBus.connect("unit_clicked", show_unit_panel)
	SignalBus.connect("monster_clicked", show_monster_panel)
	SignalBus.connect("hide_panels", hide_panels)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			hide_panels()

func hide_panels():
	$BuildingPanel.visible = false
	$UnitPanel.visible = false
	SignalBus.panels_closed.emit()

func show_building_panel(building: Building):
	$UnitPanel.visible = false
	$BuildingPanel.visible = true
	$BuildingPanel.setup(building)

func show_unit_panel(unit: TestCharacter):
	$BuildingPanel.visible = false
	$UnitPanel.visible = true
	$UnitPanel.setup(unit)

func show_monster_panel(unit: TestMonster):
	$BuildingPanel.visible = false
	$UnitPanel.visible = true
	$UnitPanel.setup_monster(unit)

func _on_construction_panel_building_selected(building: Variant) -> void:
	building_selected.emit(building)
