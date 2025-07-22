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

var effects_names: Dictionary[int, String] = {
	effect.attack_damage: "attack_damage",
	effect.attack_speed: "attack_speed",
	effect.attack_radius: "attack_radius",
	effect.attack_crit_chance: "attack_crit_chance",
	effect.attack_damage_multiplier: "attack_damage_multiplier",
	effect.attack_speed_multiplier: "attack_speed_multiplier",
	effect.attack_radius_multiplier: "attack_radius_multiplier",
	effect.attack_crit_multiplier: "attack_crit_multiplier"
}

## Dictionary of effects gained from an upgrade
@export var effects : Dictionary[effect,float] = {}
