class_name Dependancy
extends Resource

enum dependency_type{
	## Whether the cross path upgrade is purchased.
	## If chosen, the name of the dependency has to be the required upgrade name
	cross_upgrade,
}

## Type of the dependancy
@export var type: dependency_type
## Name of the dependancy
@export var name: String
