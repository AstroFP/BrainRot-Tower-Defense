class_name Replacer
extends BasicUpgradeExtension

enum replacer_type {
	interval_based,
	cooldown_based
}

## Amount of attacks between one another
@export_range(1, 100, 1, "or_greater") var interval : int

## Amount of time between attacks
@export_range(0, 100, 0.01, "or_greater") var cooldown : float
