@tool
class_name ExtraAttack
extends BasicUpgradeExtension

## Extra attack resource to be added to the tower attack logic
@export var attack_resource: BasicExtraAttack:
	set(value):
		attack_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if attack_resource:
		return attack_resource.updates
	else: 
		return []


## Cooldown of an attack in seconds
@export_range(0,10,0.01,"or_greater") var cooldown : float
