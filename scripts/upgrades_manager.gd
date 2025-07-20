class_name UpgradesManager
extends Node

# TBD:
# implement attack chnager to upgrades - replaces the default attack
# implement auras to upgrades and buffs handling to towers
# implement opdate and delete handling in attack extensions appliers
# implement ui integration with upgrade system
# design and implement complete bobritto upgrades

var tower: Tower
var tower_combat_manager: BasicCombatManager

# variables to keep track of the amount of upgrades
var upgrades : Array = []
var upgrades_amount_per_path : Dictionary[String,int] = {
	"path_1":0,
	"path_2":0,
	"path_3":0
}


func _ready() -> void:
	tower = get_parent()
	tower_combat_manager = tower.combat_manager

	# debug
	aplly_upgrade(tower.tower_stats.tower_upgrades.upgrades["path_3"]["upgrades"][0])

	aplly_upgrade(tower.tower_stats.tower_upgrades.upgrades["path_2"]["upgrades"][0])


func _process(_delta: float) -> void:
	pass


# function that applies all bonuses form an upgrade
func aplly_upgrade(upgrade:BasicUpgrade) -> void:
	apply_effects(upgrade.effects)
	apply_actions(upgrade.actions)
	apply_extra_attacks(upgrade.attacks)
	apply_attack_replacers(upgrade.replacers)
	apply_attack_enhacements(upgrade.enhancements)
	if upgrade.name not in upgrades:
		upgrades.append(upgrade.name.to_lower().to_snake_case())


# apply effects from an upgrade (raw stats boosts)
func apply_effects(effects: Effect) -> void:
	match  effects.mode:
		0: #invoke
			var effects_list = effects.effects
			for effect in effects_list:
				match effect:
					0:
						tower.attack_damage += effects_list[effect]
					1:
						tower.attack_speed += effects_list[effect]
					2:
						tower.attack_radius += effects_list[effect]
					4:
						tower.attack_crit_chance += effects_list[effect]
					5:
						tower.attack_speed_multiplier +=  effects_list[effect]
					4:
						tower.attack_damage_multiplier += effects_list[effect]
					6:
						tower.attack_radius_multiplier += effects_list[effect]
					7:
						tower.attack_crit_damage_multiplier += effects_list[effect]
					_:
						pass
		_:
			pass

# apply actions (special operations performed with basic attack)
func apply_actions(actions: Array[Action]) -> void:
	for action in actions:
		match action.mode:
			0: # invoke
				var new_action = tower_combat_manager._get_inner_action_class(action.name)
				if new_action:
					tower_combat_manager.actions[action.name] = new_action
			1: # update
				if tower_combat_manager.actions.has(action.name):
					if resolve_dependencies(action.dependencies):
						tower_combat_manager.actions[action.name].update(action.update_name)
			_:
				pass

	
# apply additional attacks (independent, with separate cooldowns)
func apply_extra_attacks(attacks: Array[ExtraAttack]) -> void:
	for attack in attacks:
		match attack.mode:
			0: # invoke
				var new_attack = tower_combat_manager._get_inner_extra_attack_class(attack.name, attack.delay)
				if new_attack:
					tower_combat_manager.extra_attacks[attack.name] = new_attack
			_:
				pass


func apply_attack_replacers(replacers: Array[AttackReplacer]) -> void:
	for replacer in replacers:
		match replacer.mode:
			0: # invoke
				var new_replacer = tower_combat_manager._get_inner_attack_replacer_class(replacer.name,replacer.interval)
				if new_replacer:
					tower_combat_manager.attack_replacers[replacer.name] = new_replacer
			_:
				pass


func apply_attack_enhacements(enhancements: Array[AttackEnhancement]) -> void:
	for enhancement in enhancements:
		match enhancement.mode:
			0: # invoke
				var new_enhancement = tower_combat_manager._get_inner_attack_enhancement_class(enhancement.name)
				if new_enhancement:
					tower_combat_manager.attack_enhancements[enhancement.name] = new_enhancement
			_:
				pass


#func apply_attack_changer(changer:Changer) -> void:
	#pass


func resolve_dependencies(dependancies: Array[Dependancy]) -> bool:
	for dependancy in dependancies:
		match dependancy.type:
			0: # cross upgrade
				if dependancy.name.to_lower().to_snake_case() not in upgrades:
					return false
			_:
				return false
	return true
