@tool
class_name BasicAttackReplacer
extends Resource

enum replacer_types {
	interval_based,
	cooldown_based
}

var replacer_interval: int
var replacer_counter: int

var replacer_cooldown: float
var replacer_cooldown_timer: float

var replacer_type: int
var replacer_function: Callable

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init(interval:int, cooldown:float, type:int, replacer_func:Callable, name:String) -> void:
	replacer_interval = interval
	replacer_counter = 0
	replacer_cooldown_timer = 0
	replacer_function = replacer_func
	replacer_cooldown = cooldown
	replacer_type = type
	resource_name = name

func should_replace(delta_time:float) -> bool:
	match replacer_type:
		replacer_types.interval_based:
			replacer_counter += 1
			if replacer_counter % replacer_interval == 0:
				replacer_counter = 0
				return true
			return false
		replacer_types.cooldown_based:
			replacer_cooldown_timer += delta_time
			if replacer_cooldown_timer >= replacer_cooldown:
				replacer_cooldown_timer = 0
				return true
			return false
		_:
			return false


func execute(params:Dictionary) -> void:
	print("attack_replaced")
	replacer_function.call(params)

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)
