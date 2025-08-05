@tool
class_name AttackChanger
extends BasicUpgradeExtension

## Changer resource to be added to the tower attack logic
@export var changer_resource: BasicAttackChanger:
	set(value):
		changer_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if changer_resource:
		return changer_resource.updates
	else: 
		return []
