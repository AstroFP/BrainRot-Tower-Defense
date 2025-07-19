class_name Replacer
extends Resource


enum mode_type{
	invoke,
	update,
	delete
}
## Mode of replacer, whether invoke new replacer, update or delete existing
@export var mode : mode_type
## Name of a replacer class
@export var name : String
## Amount of attacks between one another
@export_range(1, 100, 1, "or_greater") var interval : int
