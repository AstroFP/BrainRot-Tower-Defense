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

## Replacing attack's type of execution
@export var execution_type : BasicAttackReplacer.replacer_types:
	set(value):
		execution_type = value
		notify_property_list_changed()

## Amount of attacks between one another
var interval : int

## Amount of time between attacks
var cooldown : float


func _get_property_list():
	var properties = []
	
	match execution_type:
		BasicAttackReplacer.replacer_types.interval_based:
			properties.append({
				"name": "interval",
				"type": TYPE_INT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "1,100,1,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicAttackReplacer.replacer_types.cooldown_based:
			properties.append({
				"name": "cooldown",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,10,0.01,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})

	return properties
