class_name Action
extends Resource


enum mode_type{
	invoke,
	update,
	delete
}
## Mode of action, whether invoke new action, update or delete existing
@export var mode : mode_type
## Name of action class
@export var name : String
