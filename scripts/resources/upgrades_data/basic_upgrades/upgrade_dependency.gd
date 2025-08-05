class_name Dependency
extends Resource

enum types{
	is_cross_path_upgrade,
	is_not_cross_path_upgrade
}

## Type of the dependency
@export var type : types = types.is_cross_path_upgrade
## Name of the dependency
@export var name: String
