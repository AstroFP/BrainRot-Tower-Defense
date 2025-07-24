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

## Extra attack's type of execution
@export var execution_type : BasicExtraAttack.extra_attack_types:
	set(value):
		execution_type = value
		notify_property_list_changed()

## Chance of an attack to execute: 0% - 100%
var proc_chance: float

## Amount of attacks between one another: e.g. execute every 3rd attack
var interval: int

## Cooldown of an attack in seconds
var cooldown : float

# Override  get_property_list from BasicUpgradeExtension 
# to include extra attack type selection
func _get_property_list():
	var properties = []
	
	match execution_type:
		BasicExtraAttack.extra_attack_types.proc_chance_based:
			properties.append({
				"name": "proc_chance",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "1,100,0.01",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicExtraAttack.extra_attack_types.interval_based:
			properties.append({
				"name": "interval",
				"type": TYPE_INT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "1,100,1,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BasicExtraAttack.extra_attack_types.cooldown_based:
			properties.append({
				"name": "cooldown",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0,10,0.01,or_greater",
				"usage": PROPERTY_USAGE_DEFAULT
			})

	return properties
