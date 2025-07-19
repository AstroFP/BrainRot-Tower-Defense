class_name UpgradesManager
extends Node

var tower: Tower
var tower_combat_manager: BasicCombatManager
#var upgrades : Array = []


func _ready() -> void:
	tower = get_parent()
	tower_combat_manager = tower.combat_manager

	# debug
	aplly_upgrade(tower.tower_stats.tower_upgrades.upgrades["paths"]["path_2"]["upgrades"][0])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# function that applies all bonuses form an upgrade
func aplly_upgrade(upgrade:Dictionary) -> void:
	apply_effects(upgrade["effects"])
	apply_actions(upgrade["actions"])
	apply_additional_attacks(upgrade["attacks"])

# apply effects from an upgrade (raw stats boosts)
func apply_effects(effects: Dictionary) -> void:
	for effect_name in effects:
		match effect_name:
			"attack_speed_multiplier":
				tower.attack_speed_multiplier +=  effects[effect_name]
			"attack_damage_multiplier":
				tower.attack_damage_multiplier += effects[effect_name]
			"attack_radius_multiplier":
				tower.attack_radius_multiplier += effects[effect_name]
			"attack_damage":
				tower.attack_damage += effects[effect_name]
			"attack_speed":
				tower.attack_speed += effects[effect_name]
			"attack_radius":
				tower.attack_radius += effects[effect_name]
			_:
				pass


# apply actions (special operations performed with basic attack)
func apply_actions(actions: Array) -> void:
	for action in actions:
		if !action.is_empty():
			tower_combat_manager.actions.append(tower_combat_manager._get_inner_action_class(action["name"]))

			
# apply additional attacks (independent, with separate cooldowns)
func apply_additional_attacks(attacks: Array) -> void:
	for attack in attacks:
		if !attack.is_empty():
			tower_combat_manager.additional_attacks.append(tower_combat_manager._get_inner_attack_class(attack["name"],attack["delay"]))
