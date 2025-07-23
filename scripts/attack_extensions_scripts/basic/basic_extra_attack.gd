@tool
class_name BasicExtraAttack
extends Resource

var attack_delay: float
var attack_timer: float
var attack_function: Callable

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init(att_delay: float, att_func: Callable, name:String) -> void:
	attack_delay = att_delay
	attack_timer = 0
	attack_function = att_func
	resource_name = name

func execute(params:Dictionary) -> void:
	attack_timer += params["delta_time"]
	if attack_timer >= attack_delay:
		attack_function.call(params)
		attack_timer = 0

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)
