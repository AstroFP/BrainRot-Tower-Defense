@tool
class_name BasicExtraAttack
extends Resource

enum extra_attack_types {
	proc_chance_based,
	interval_based,
	cooldown_based
}

@export var attack_delay: float
var attack_timer: float
var attack_function: Callable
@export var extra_attack_type: extra_attack_types

@export var extra_attack_interval: int
var extra_attack_counter: int

@export var extra_attack_proc_chance: float

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init() -> void:
	attack_timer = 0
	extra_attack_counter = 0
	attack_function = basic_extra_attack
	resource_name = "basic_extra_attack"

func execute(params:Dictionary) -> void:
	attack_function.call(params)

func should_execute(delta_time:float) -> bool:
	match extra_attack_type:
		extra_attack_types.proc_chance_based:
			var roll = randf() * 100.0
			if roll < extra_attack_proc_chance:
				return true
		extra_attack_types.interval_based:
			extra_attack_counter += 1
			if extra_attack_counter % extra_attack_interval == 0:
				extra_attack_counter = 0
				return true
		extra_attack_types.cooldown_based:
			attack_timer += delta_time
			if attack_timer >= attack_delay:
				attack_timer = 0
				return true
		_:
			return false
	return false

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)

func basic_extra_attack(params:Dictionary) -> void:
	print_debug("Extra attack: ",params["target"])
