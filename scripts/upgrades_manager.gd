class_name UpgradesManager
extends Node

# TBD:
# implement auras to upgrades and buffs handling to towers
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
	apply_attack_changer(upgrade.changer)
	if upgrade.name not in upgrades:
		upgrades.append(upgrade.name.to_snake_case())
	
	#TBD while implementing ui integration increment upgrades_amount_per_path accordingly


# apply effects from an upgrade (raw stats boosts)
func apply_effects(effects: Array[Effect]) -> void:
	for effect in effects:
		if resolve_dependencies(effect.dependencies):
			var effects_list = effect.effects
			for effects_list_item in effects_list:
				var effect_name = effect.effects_type.find_key(effects_list_item)
				tower.update_tower_stat_by_string_name(effect_name, effects_list[effects_list_item])

# apply actions (special operations performed with basic attack)
func apply_actions(actions: Array[AttackAction]) -> void:
	for action in actions:
		var action_name = action.action_resource.resource_name.to_snake_case()
		match action.mode:
			action.mode_type.invoke:
				if !tower_combat_manager.attack_actions.has(action_name):
					if resolve_dependencies(action.dependencies):
						action.action_resource.action_proc_chance = action.proc_chance
						action.action_resource.action_interval = action.interval
						action.action_resource.action_cooldown = action.cooldown
						tower_combat_manager.attack_actions[action_name] = action.action_resource
			action.mode_type.update:
				if tower_combat_manager.attack_actions.has(action_name):
					if resolve_dependencies(action.dependencies):
						var args: Dictionary = {
							"type": action.execution_type,
							"proc_chance": action.proc_chance,
							"interval": action.interval,
							"cooldown": action.cooldown
						}
						tower_combat_manager.attack_actions[action_name].update(action.selected_update, args)
			action.mode_type.delete:
				if tower_combat_manager.attack_actions.has(action_name):
					if resolve_dependencies(action.dependencies):
						tower_combat_manager.attack_actions.erase(action_name)
			_:
				pass

# apply additional attacks (independent, with separate cooldowns)
func apply_extra_attacks(attacks: Array[ExtraAttack]) -> void:
	for attack in attacks:
		var attack_name = attack.attack_resource.resource_name.to_snake_case()
		match attack.mode:
			attack.mode_type.invoke:
				if !tower_combat_manager.extra_attacks.has(attack_name):
					if resolve_dependencies(attack.dependencies):
						attack.attack_resource.attack_cooldown = attack.cooldown
						tower_combat_manager.extra_attacks[attack_name] = attack.attack_resource
			attack.mode_type.update:
				if tower_combat_manager.extra_attacks.has(attack_name):
					if resolve_dependencies(attack.dependencies):
						var args : Dictionary = {
							"cooldown": attack.cooldown
						}
						tower_combat_manager.extra_attacks[attack_name].update(attack.selected_update,args)
			attack.mode_type.delete:
				if tower_combat_manager.extra_attacks.has(attack_name):
					if resolve_dependencies(attack.dependencies):
						tower_combat_manager.extra_attacks.erase(attack_name)
			_:
				pass


func apply_attack_replacers(replacers: Array[AttackReplacer]) -> void:
	for replacer in replacers:
		var replacer_name = replacer.replacer_resource.resource_name.to_snake_case()
		match replacer.mode:
			replacer.mode_type.invoke:
				if !tower_combat_manager.attack_replacers.has(replacer_name):
					if resolve_dependencies(replacer.dependencies):
						replacer.replacer_resource.replacer_type = replacer.execution_type
						replacer.replacer_resource.replacer_interval = replacer.interval
						replacer.replacer_resource.replacer_cooldown = replacer.cooldown
						tower_combat_manager.attack_replacers[replacer_name] = replacer.replacer_resource
			replacer.mode_type.update:
				if tower_combat_manager.attack_replacers.has(replacer_name):
					if resolve_dependencies(replacer.dependencies):
						var args: Dictionary = {
							"type": replacer.execution_type,
							"interval": replacer.interval,
							"cooldown": replacer.cooldown
						}
						tower_combat_manager.attack_replacers[replacer_name].update(replacer.selected_update,args)
			replacer.mode_type.delete:
				if tower_combat_manager.attack_replacers.has(replacer_name):
					if resolve_dependencies(replacer.dependencies):
						tower_combat_manager.attack_replacers.erase(replacer_name)
			_:
				pass


func apply_attack_enhacements(enhancements: Array[AttackEnhancement]) -> void:
	for enhancement in enhancements:
		var enhancement_name = enhancement.enhancement_resource.resource_name
		match enhancement.mode:
			enhancement.mode_type.invoke:
				if !tower_combat_manager.attack_enhancements.has(enhancement_name):
					if resolve_dependencies(enhancement.dependencies):
						enhancement.enhancement_resource.enhancement_type = enhancement.execution_type
						enhancement.enhancement_resource.enhancement_proc_chance = enhancement.proc_chance
						enhancement.enhancement_resource.enhancement_cooldown = enhancement.cooldown
						tower_combat_manager.attack_enhancements[enhancement_name] = enhancement.enhancement_resource
			enhancement.mode_type.update:
				if tower_combat_manager.attack_enhancements.has(enhancement_name):
					if resolve_dependencies(enhancement.dependencies):
						var args: Dictionary = {
							"type": enhancement.execution_type,
							"proc_chance": enhancement.proc_chance,
							"cooldown": enhancement.cooldown
						}
						tower_combat_manager.attack_enhancements[enhancement_name].update(enhancement.selected_update,args)
			enhancement.mode_type.delete:
				if tower_combat_manager.attack_enhancements.has(enhancement_name):
					if resolve_dependencies(enhancement.dependencies):
						tower_combat_manager.attack_enhancements.erase(enhancement_name)
			_:
				pass


func apply_attack_changer(changer:AttackChanger) -> void:
	if !changer:
		return
	match changer.mode:
		changer.mode_type.invoke:
			tower_combat_manager.attack_changer = changer.changer_resource
		changer.mode_type.update:
			if tower_combat_manager.attack_changer.resource_name == changer.changer_resource.resource_name:
				if resolve_dependencies(changer.dependencies):
					var args: Dictionary = {}
					tower_combat_manager.attack_changer.update(changer.selected_update, args)
		changer.mode_type.delete:
			if tower_combat_manager.attack_changer.resource_name == changer.changer_resource.resource_name:
				if resolve_dependencies(changer.dependencies):
					tower_combat_manager.attack_changer = null
		_:			
			pass


func resolve_dependencies(dependancies: Array[Dependancy]) -> bool:
	for dependancy in dependancies:
		match dependancy.type:
			dependancy.types.is_cross_path_upgrade:
				if dependancy.name.to_snake_case() not in upgrades:
					return false
			dependancy.types.is_not_cross_path_upgrade:
				if dependancy.name.to_snake_case() in upgrades:
					return false
			_:
				return false
	return true
