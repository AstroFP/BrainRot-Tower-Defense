class_name BasicUpgradeExtension
extends Resource

enum mode_type{
	invoke,
	update,
	delete
}
## Mode of attack extension, whether invoke new one, update or delete existing
@export var mode : mode_type
## Name of attack extension class to perform upgrade on (invoke, update, delete)
@export var name : String
## Intended for update mode if the update is to occur only when the criteria are met
@export var dependencies : Array[Dependancy]
## If update mode: name of an update to perform on given class
@export var update_name : String
