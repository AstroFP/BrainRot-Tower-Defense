@tool
class_name BasicAttackEnhancement
extends Resource

enum enhacement_types {
	proc_chance_based,
	cooldown_based
}

@export var enhancement_damage: float
@export var enhancement_cooldown: float
var enhancement_cooldown_counter: float
@export var enhancement_proc_chance: float
var enhancement_function: Callable
@export var enhancement_type: enhacement_types

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init() -> void:
	enhancement_cooldown_counter = 0
	enhancement_proc_chance = clamp(enhancement_proc_chance, 0, 100)
	resource_name = "basic_attack_enhancement"
	enhancement_function = basic_enhancement

func apply(params:Dictionary) -> void:
	enhancement_function.call(params)


func should_enhance(delta_time: float) ->  bool:
	match enhancement_type:
		enhacement_types.proc_chance_based:
			var roll = randf() * 100.0
			if roll < enhancement_proc_chance:
				return true
		enhacement_types.cooldown_based:
			enhancement_cooldown_counter += delta_time
			if enhancement_cooldown_counter >= enhancement_cooldown:
				enhancement_cooldown_counter = 0
				return true
		_:
			return false
	return false


func basic_enhancement(params:Dictionary) -> void:
	print_debug("basic attack enhancement: ",params["damage"])

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)
