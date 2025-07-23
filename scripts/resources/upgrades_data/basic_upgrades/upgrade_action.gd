@tool
class_name Action
extends BasicUpgradeExtension

## Action resource to be added to the tower attack logic
@export var action_resource: BasicAction:
	set(value):
		action_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if action_resource:
		return action_resource.updates
	else: 
		return []
