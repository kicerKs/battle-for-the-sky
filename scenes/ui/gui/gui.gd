extends CanvasLayer

signal building_selected(building)

var time_in_seconds = 0

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
	
	SignalBus.connect("player_eliminated", show_defeat)
	SignalBus.connect("player_won", show_victory)
	SignalBus.connect("config_loaded", setup_sliders)
	Lobby.server_disconnected.connect(show_leave_panel)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			hide_panels()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		%PauseMenu.visible = !%PauseMenu.visible

func setup_sliders():
	$PauseMenu/MarginContainer/VBoxContainer/GridContainer/HSlider.value = AudioManager.music_volume
	$PauseMenu/MarginContainer/VBoxContainer/GridContainer/HSlider2.value = AudioManager.sound_volume

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

func show_leave_panel():
	%JoiningGameBox.visible = true

func _on_join_button_pressed() -> void:
	get_tree().quit()

@rpc("call_local", "any_peer", "reliable")
func show_victory(id):
	if id == multiplayer.get_unique_id():
		%WinScreen.visible = true

@rpc("call_local", "any_peer", "reliable")
func show_defeat(id):
	if id == multiplayer.get_unique_id():
		%DefeatScreen.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.music_volume = value


func _on_h_slider_2_value_changed(value: float) -> void:
	AudioManager.sound_volume = value


func _on_timer_timeout() -> void:
	time_in_seconds += 1
	Global.set_game_time(time_in_seconds)
	var m = int(time_in_seconds / 60.0)
	var s = time_in_seconds - m * 60
	%Timer.text = '%02d:%02d' % [m, s]
