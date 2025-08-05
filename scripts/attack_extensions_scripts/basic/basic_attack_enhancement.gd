@tool
class_name BasicAttackEnhancement
extends Resource

enum enhancement_types {
	always_active,
	proc_chance_based,
	cooldown_based
}

@export var enhancement_damage: float
@export var enhancement_cooldown: float
var enhancement_cooldown_counter: float
@export var enhancement_proc_chance: float
var enhancement_function: Callable
@export var enhancement_type: enhancement_types

var updates: Array[String] = ["none", "change_execution_type"]

func _init() -> void:
	enhancement_cooldown_counter = 0
	enhancement_proc_chance = clamp(enhancement_proc_chance, 0, 100)
	resource_name = "basic_attack_enhancement"
	enhancement_function = basic_enhancement

func apply(params:Dictionary) -> void:
	enhancement_function.call(params)


func should_enhance(delta_time: float) ->  bool:
	match enhancement_type:
		enhancement_types.always_active:
			return true
		enhancement_types.proc_chance_based:
			var roll = randf() * 100.0
			if roll < enhancement_proc_chance:
				return true
		enhancement_types.cooldown_based:
			enhancement_cooldown_counter += delta_time
			if enhancement_cooldown_counter >= enhancement_cooldown:
				enhancement_cooldown_counter = 0
				return true
		_:
			return false
	return false


func basic_enhancement(params:Dictionary) -> void:
	print_debug("basic attack enhancement: ",params["damage"])

func update(update_name: String, update_args: Dictionary) -> void:
	match  update_name:
		"change_execution_type":
			change_execution_type(update_args)
		_:
			pass
	print_debug("Update: ", update_name)


func change_execution_type(args: Dictionary) -> void:
	enhancement_type = args["type"]
	match enhancement_type:
		enhancement_types.proc_chance_based:
			enhancement_proc_chance = args["proc_chance"]
		enhancement_types.cooldown_based:
			enhancement_cooldown = args["cooldown"]
		_:
			pass
