class_name BasicUpgradeExtension
extends Resource

enum mode_type{
	invoke,
	update,
	delete
}
## Mode of attack extension, whether invoke new one, update or delete existing
@export var mode : mode_type
## Name of action class to perform upgrade on (invoke, update, delete)
@export var name : String
## Intended for update mode if the update is to occur only when the criteria are met
@export var dependencies : Array[Dependancy]
## Intended for update mode, name of the update to perform
@export var update_name : String
