class_name Effect
extends BasicUpgradeExtension

enum effect {
	attack_damage,
	attack_speed,
	attack_radius,
	attack_crit_chance,
	attack_damage_multiplier,
	attack_speed_multiplier,
	attack_radius_multiplier,
	attack_crit_multiplier
}

## Dictionary of effects gained from an upgrade
@export var effects : Dictionary[effect,float] = {}
