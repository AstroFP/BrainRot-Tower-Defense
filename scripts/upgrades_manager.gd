class_name UpgradesManager
extends Node

# TBD:
# refactor all atack extensions to utilize the resource approach
# implement attack chnager to upgrades - replaces the default attack
# implement auras to upgrades and buffs handling to towers
# implement update and delete handling in attack extensions appliers
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
		match effect.mode:
			effect.mode_type.invoke:
				var effects_list = effect.effects
				for effect_list_item in effects_list:
					var effect_name = effect.effects_type.find_key(effect_list_item)
					tower.update_tower_stat_by_string_name(effect_name, effects_list[effect_list_item])
			effect.mode_type.update:
				pass
			effect.mode_type.delete:
				pass
			_:
				pass

# apply actions (special operations performed with basic attack)
func apply_actions(actions: Array[AttackAction]) -> void:
	for action in actions:
		var action_name = action.action_resource.resource_name.to_snake_case()
		match action.mode:
			action.mode_type.invoke:
				# add action resource to a actions dictionary with its name as a key
				tower_combat_manager.attack_actions[action_name] = action.action_resource
			action.mode_type.update:
				if tower_combat_manager.attack_actions.has(action_name):
					if resolve_dependencies(action.dependencies):
						tower_combat_manager.attack_actions[action_name].update(action.selected_update)
			action.mode_type.delete:
				pass
			_:
				pass

	
# apply additional attacks (independent, with separate cooldowns)
func apply_extra_attacks(attacks: Array[ExtraAttack]) -> void:
	for attack in attacks:
		var attack_name = attack.attack_resource.resource_name.to_snake_case()
		match attack.mode:
			attack.mode_type.invoke:
				tower_combat_manager.extra_attacks[attack_name] = attack.attack_resource
			attack.mode_type.update:
				pass
			attack.mode_type.delete:
				pass
			_:
				pass


func apply_attack_replacers(replacers: Array[AttackReplacer]) -> void:
	for replacer in replacers:
		var replacer_name = replacer.replacer_resource.resource_name.to_snake_case()
		match replacer.mode:
			replacer.mode_type.invoke:
				tower_combat_manager.attack_replacers[replacer_name] = replacer.replacer_resource
			replacer.mode_type.update:
				pass
			replacer.delete:
				pass
			_:
				pass


func apply_attack_enhacements(enhancements: Array[AttackEnhancement]) -> void:
	for enhancement in enhancements:
		var enhancement_name = enhancement.enhancement_resource.resource_name
		match enhancement.mode:
			enhancement.mode_type.invoke:
				enhancement.enhancement_resource.enhancement_type = enhancement.type
				enhancement.enhancement_resource.enhancement_proc_chance = enhancement.proc_chance
				enhancement.enhancement_resource.enhancement_cooldown = enhancement.cooldown
				tower_combat_manager.attack_enhancements[enhancement_name] = enhancement.enhancement_resource
			enhancement.mode_type.update:
				pass
			enhancement.mode_type.delete:
				pass
			_:
				pass


func apply_attack_changer(changer:AttackChanger) -> void:
	if changer:
		match changer.mode:
			changer.mode_type.invoke:
				tower_combat_manager.attack_changer = changer.changer_resource
			changer.mode_type.update:
				pass
			changer.mode_type.delete:
				pass
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
