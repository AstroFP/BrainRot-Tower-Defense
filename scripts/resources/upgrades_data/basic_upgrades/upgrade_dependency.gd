class_name Dependancy
extends Resource

enum types{
	is_cross_path_upgrade,
	is_not_cross_path_upgrade
}

## Type of the dependancy
@export var type : types = types.is_cross_path_upgrade
## Name of the dependancy
@export var name: String
