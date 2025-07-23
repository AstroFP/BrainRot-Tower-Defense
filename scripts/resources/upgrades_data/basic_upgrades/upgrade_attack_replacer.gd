@tool
class_name AttackReplacer
extends BasicUpgradeExtension



## Replacer resource to be added to the tower attack logic
@export var replacer_resource: BasicAttackReplacer:
	set(value):
		replacer_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if replacer_resource:
		return replacer_resource.updates
	else: 
		return []

## Type of replacing attack
@export var type : BasicAttackReplacer.replacer_types

## Amount of attacks between one another
@export_range(1, 100, 1, "or_greater") var interval : int

## Amount of time between attacks
@export_range(0, 100, 0.01, "or_greater") var cooldown : float
