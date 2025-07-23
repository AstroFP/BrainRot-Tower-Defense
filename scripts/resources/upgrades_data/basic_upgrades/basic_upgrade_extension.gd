class_name BasicUpgradeExtension
extends Resource

enum mode_type {
	## Add new instance of the attack extension to the tower
	invoke, 
	## Update existing attack extension with chosen update
	update, 
	## Delete existing attack extension
	delete
}

### Name of attack extension class to perform upgrade on (invoke, update, delete)
#@export var name : String
## Array of dependencies ensuring given attack extension is applied only when the criteria are met
@export var dependencies : Array[Dependancy]

## Mode of attack extension in which it should be applied
@export var mode: mode_type = mode_type.invoke:
	set(value):
			mode = value
			notify_property_list_changed()

## Update to perform on the attack extension with current upgrade
var selected_update: String = ""

func _get_property_list() -> Array:
	var props = []
	if mode == mode_type.update:
		props.append({
			"name": "selected_update",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(get_update()),
			"usage": PROPERTY_USAGE_DEFAULT,
		})
	return props

func get_update() -> Array:
	return []
