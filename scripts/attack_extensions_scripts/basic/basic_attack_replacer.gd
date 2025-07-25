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

var updates: Array[String] = ["none", "change_execution_type"]

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

func update(update_name: String, update_args:Dictionary) -> void:
	match update_name:
		"change_execution_type":
			change_execution_type(update_args)
		_:
			pass
	print_debug("Update: ", update_name)

func change_execution_type(args:Dictionary) -> void:
	match args["type"]:
		replacer_types.always_active:
			replacer_type = replacer_types.always_active
		replacer_types.interval_based:
			replacer_interval = args["interval"]
			replacer_type = replacer_types.interval_based
		replacer_types.cooldown_based:
			replacer_cooldown = args["cooldown"]
			replacer_type = replacer_types.cooldown_based
		_:
			pass


func basic_replacer(params: Dictionary) -> void:
	print_debug("attack replaced: ", params["target"])
