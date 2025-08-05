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


## Attack enhancement's type of execution
@export var execution_type : BasicAttackEnhancement.enhancement_types:
	set(value):
		execution_type = value
		notify_property_list_changed()

## Chnace of enhancement to activate
var proc_chance : float

## Amount of time between enhancements
var cooldown : float


func _get_property_list():
	var properties = []
	
	match execution_type:
		BasicAttackEnhancement.enhancement_types.proc_chance_based:
			properties.append({
				"name": "proc_chance",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,100,0.01",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicAttackEnhancement.enhancement_types.cooldown_based:
			properties.append({
				"name": "cooldown",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,10,0.01,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})

	return properties
