extends PanelContainer

var melee_range_icon = load("res://assets/icons/meele range.png")
var distance_range_icon = load("res://assets/icons/distance range.png")
var single_target_icon = load("res://assets/icons/single target.png")
var aoe_target_icon = load("res://assets/icons/AOE.png")
var damage_icon = load("res://assets/icons/inflict dmg.png")
var heal_icon = load("res://assets/icons/heal.png")

func setup(unit: TestCharacter):
	%character_name.text = unit.stats.name
	%Description.text = unit.stats.description
	%hp_label.text = str(unit.health_component.current_hp) + "/" + str(unit.stats.max_hp)
	%attack_label.text = str(unit.stats.action)
	%defense_label.text = str(unit.stats.armor)
	%spd_label.text = str(unit.stats.speed)
	%attspd_label.text = str(unit.stats.actionSpeed)
	%UnitIcon.texture = unit.stats.icon
	if unit.stats.range <= unit.stats.maximum_melee_range:
		%RangeIcon.texture = melee_range_icon
	else:
		%RangeIcon.texture = distance_range_icon
	if unit.stats.singleTarget:
		%AOEIcon.texture = single_target_icon
	else:
		%AOEIcon.texture = aoe_target_icon
	%DamageHealIcon.visible = true
	if unit.get_node("Components").has_node("AttackComponent"):
		%DamageHealIcon.texture = damage_icon
	elif unit.get_node("Components").has_node("HealComponent"):
		%DamageHealIcon.texture = heal_icon
	else:
		%DamageHealIcon.visible = false

func setup_monster(unit: TestMonster):
	%character_name.text = unit.stats.name
	%Description.text = unit.stats.description
	%hp_label.text = str(unit.health_component.current_hp) + "/" + str(unit.stats.max_hp)
	%attack_label.text = str(unit.stats.action)
	%defense_label.text = str(unit.stats.armor)
	%spd_label.text = str(unit.stats.speed)
	%attspd_label.text = str(unit.stats.actionSpeed)
	%UnitIcon.texture = unit.stats.icon
	if unit.stats.range <= unit.stats.maximum_melee_range:
		%RangeIcon.texture = melee_range_icon
	else:
		%RangeIcon.texture = distance_range_icon
	if unit.stats.singleTarget:
		%AOEIcon.texture = single_target_icon
	else:
		%AOEIcon.texture = aoe_target_icon
	%DamageHealIcon.visible = true
	if unit.get_node("Components").has_node("AttackComponent"):
		%DamageHealIcon.texture = damage_icon
	elif unit.get_node("Components").has_node("HealComponent"):
		%DamageHealIcon.texture = heal_icon
	else:
		%DamageHealIcon.visible = false
