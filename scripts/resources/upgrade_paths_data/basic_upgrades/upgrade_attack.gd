class_name Attack
extends Resource


enum mode_type{
	invoke,
	update,
	delete
}
## Mode of extra attack, whether invoke new attack, update or delete existing
@export var mode : mode_type
## Name of extra attack class
@export var name : String
## Cooldown of an attack
@export_range(0, 1, 0.01, "or_greater") var delay : float
