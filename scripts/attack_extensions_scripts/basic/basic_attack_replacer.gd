@tool
class_name BasicAttackReplacer
extends Resource

enum replacer_types {
	always_active,
	interval_based,
	cooldown_based
}

@export var replacer_interval: int
var replacer_counter: int

@export var replacer_cooldown: float
var replacer_cooldown_timer: float

@export var replacer_type: replacer_types
var replacer_function: Callable

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init() -> void:
	replacer_counter = 0
	replacer_cooldown_timer = 0
	replacer_function = basic_replacer
	resource_name = "basic_attack_replacer"

func should_replace(delta_time:float) -> bool:
	match replacer_type:
		replacer_types.always_active:
			return true
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
	replacer_function.call(params)

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)

func basic_replacer(params: Dictionary) -> void:
	print_debug("attack replaced: ", params["target"])
