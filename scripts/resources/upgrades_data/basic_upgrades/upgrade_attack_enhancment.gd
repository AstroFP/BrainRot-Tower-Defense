@tool
class_name AttackEnhancement
extends BasicUpgradeExtension


## Enhancement resource to be added to the tower attack logic
@export var enhancement_resource: BasicAttackEnhancement:
	set(value):
		enhancement_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if enhancement_resource:
		return enhancement_resource.updates
	else: 
		return []


## Type of enhancement
@export var type : BasicAttackEnhancement.enhacement_types

## Chnace of enhancement to activate
@export_range(0, 100, 0.01) var proc_chance : float

## Amount of time between enhancements
@export_range(0, 100, 0.01, "or_greater") var cooldown : float
