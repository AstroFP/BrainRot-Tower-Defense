class_name UpgradesManager
extends Node

var tower: Tower
var tower_combat_manager: BasicCombatManager
#var upgrades : Array = []


func _ready() -> void:
	tower = get_parent()
	tower_combat_manager = tower.combat_manager

	# debug
	aplly_upgrade(tower.tower_stats.tower_upgrades.upgrades["path_2"]["upgrades"][0])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# function that applies all bonuses form an upgrade
func aplly_upgrade(upgrade:BasicUpgrade) -> void:
	apply_effects(upgrade.effects)
	apply_actions(upgrade.actions)
	apply_extra_attacks(upgrade.attacks)
	apply_attack_replacers(upgrade.replacers)
	apply_attack_enhacements(upgrade.enhancements)

# apply effects from an upgrade (raw stats boosts)
func apply_effects(effects: Dictionary) -> void:
	print(effects)
	for effect in effects:
		match effect:
			0:
				tower.attack_damage += effects[effect]
			1:
				tower.attack_speed += effects[effect]
			2:
				tower.attack_radius += effects[effect]
			4:
				tower.attack_crit_chance += effects[effect]
			5:
				tower.attack_speed_multiplier +=  effects[effect]
			4:
				tower.attack_damage_multiplier += effects[effect]
			6:
				tower.attack_radius_multiplier += effects[effect]
			7:
				tower.attack_crit_damage_multiplier += effects[effect]
			_:
				pass


# apply actions (special operations performed with basic attack)
func apply_actions(actions: Array) -> void:
	for action in actions:
		match action.mode:
			0:
				var new_action = tower_combat_manager._get_inner_action_class(action.name)
				if new_action:
					tower_combat_manager.actions[action.name] = new_action
			_:
				pass
			
# apply additional attacks (independent, with separate cooldowns)
func apply_extra_attacks(attacks: Array) -> void:
	for attack in attacks:
		match attack.mode:
			0:
				var new_attack = tower_combat_manager._get_inner_extra_attack_class(attack.name, attack.delay)
				if new_attack:
					tower_combat_manager.extra_attacks[attack.name] = new_attack
			_:
				pass

func apply_attack_replacers(replacers: Array) -> void:
	for replacer in replacers:
		match replacer.mode:
			0:
				var new_replacer = tower_combat_manager._get_inner_attack_replacer_class(replacer.name,replacer.interval)
				if new_replacer:
					tower_combat_manager.attack_replacers[replacer.name] = new_replacer
			_:
				pass

func apply_attack_enhacements(enhancements: Array) -> void:
	for enhancement in enhancements:
		match enhancement.mode:
			0:
				var new_enhancement = tower_combat_manager._get_inner_attack_enhancement_class(enhancement.name)
				if new_enhancement:
					tower_combat_manager.attack_enhancements[enhancement.name] = new_enhancement
			_:
				pass

#func apply_attack_changer(changers:Array) -> void:
	#pass
