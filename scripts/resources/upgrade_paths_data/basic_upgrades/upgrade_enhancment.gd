class_name Enhancement
extends Resource


enum mode_type{
	invoke,
	update,
	delete
}
## Mode of enhancement, whether invoke new enhancement, update or delete existing
@export var mode : mode_type
## Name of enhancement class
@export var name: String
