@tool
class_name AttackAction
extends BasicUpgradeExtension

## Action resource to be added to the tower attack logic
@export var action_resource: BasicAttackAction:
	set(value):
		action_resource = value
		notify_property_list_changed()


func get_update() -> Array:
	if action_resource:
		return action_resource.updates
	else: 
		return []

## Replacing attack's type of execution
@export var execution_type : BasicAttackAction.action_types:
	set(value):
		execution_type = value
		notify_property_list_changed()

## Chance of the action to execute
var proc_chance: float

## Amount of attacks between one another
var interval : int

## Amount of time between attacks
var cooldown : float


func _get_property_list():
	var properties = []
	
	match execution_type:
		BasicAttackAction.action_types.proc_chance_based:
			properties.append({
				"name": "proc_chance",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,100,0.01",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicAttackAction.action_types.interval_based:
			properties.append({
				"name": "interval",
				"type": TYPE_INT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "1,100,1,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicAttackAction.action_types.cooldown_based:
			properties.append({
				"name": "cooldown",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,10,0.01,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})

	return properties
