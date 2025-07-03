extends Control

var current_tutorial = 0:
	set(value):
		current_tutorial = value
		change_tutorial_boxes()

func _ready():
	SignalBus.building_built.connect(set_tutorial_4)
	SignalBus.hide_panels.connect(set_tutorial_5)
	SignalBus.island_conquered.connect(set_tutorial_9)
	%Tutorial0.enable()
	$"../ConstructionPanel2".get_node("%Woodcutter").get_node("Button").disabled = true
	$"../ConstructionPanel2".get_node("%Farm").get_node("Button").disabled = true
	$"../ConstructionPanel2".get_node("%House").get_node("Button").disabled = true

func set_tutorial_9(bef, aft):
	if current_tutorial == 8:
		current_tutorial = 9

func set_tutorial_4(side):
	if current_tutorial == 6:
		current_tutorial = 7
	if current_tutorial == 5:
		current_tutorial = 6
	if current_tutorial == 3:
		current_tutorial = 4

func set_tutorial_5():
	if current_tutorial == 4:
		current_tutorial = 5

func change_tutorial_boxes():
	if current_tutorial == 1:
		%Tutorial0.disable()
		%Tutorial1.enable()
	if current_tutorial == 2:
		%Tutorial1.disable()
		%Tutorial2.enable()
	if current_tutorial == 3:
		%Tutorial2.disable()
		%Tutorial3.enable()
		$"../ConstructionPanel2".get_node("%Woodcutter").get_node("Button").disabled = false
	if current_tutorial == 4:
		%Tutorial3.disable()
		%Tutorial4.enable()
		$"../ConstructionPanel2".get_node("%Woodcutter").get_node("Button").disabled = true
	if current_tutorial == 5:
		%Tutorial4.disable()
		%Tutorial5.enable()
		$"../ConstructionPanel2".get_node("%Farm").get_node("Button").disabled = false
	if current_tutorial == 6:
		%Tutorial5.disable()
		%Tutorial6.enable()
		$"../ConstructionPanel2".get_node("%Farm").get_node("Button").disabled = true
		$"../ConstructionPanel2".get_node("%House").get_node("Button").disabled = false
	if current_tutorial == 7:
		%Tutorial6.disable()
		%Tutorial7.enable()
		$"../ConstructionPanel2".get_node("%Farm").get_node("Button").disabled = false
		$"../ConstructionPanel2".get_node("%Woodcutter").get_node("Button").disabled = false
	if current_tutorial == 8:
		%Tutorial7.disable()
		%Tutorial8.enable()
	if current_tutorial == 9:
		%Tutorial8.disable()
		%Tutorial9.enable()
	if current_tutorial == 10:
		%Tutorial9.disable()
