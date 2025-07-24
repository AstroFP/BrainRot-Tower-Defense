@tool
class_name BasicAttackAction
extends Resource

enum action_types {
	always_active,
	proc_chance_based,
	interval_based,
	cooldown_based
}

var action_type: action_types
var action_interval: int
var action_counter: int

var action_cooldown: float
var action_cooldown_timer: float

var action_proc_chance: float

var action_function: Callable
var updates: Array[String] = ["none", "change_execution_type"]

func _init() -> void:
	action_counter = 0
	action_cooldown_timer = 0
	action_function = basic_attack_action
	resource_name ="basic_attack_action"
	updates += ["lol"]
	

func set_action_function(action_func:Callable) -> void:
	action_function = action_func


func should_execute(delta_time:float) -> bool:
	match action_type:
		action_types.always_active:
			return true
		action_types.proc_chance_based:
			var roll = randf() * 100.0
			if roll < action_proc_chance:
				return true
		action_types.interval_based:
			action_counter += 1
			if action_counter % action_interval == 0:
				action_counter = 0
				return true
		action_types.cooldown_based:
			action_cooldown_timer += delta_time
			if action_cooldown_timer >= action_cooldown:
				action_cooldown_timer = 0
				return true
		_:
			return false
	return false

func execute(params:Dictionary) -> void:
	action_function.call(params)

func basic_attack_action(params:Dictionary) -> void:
	print_debug("basic action on: ", params["target"])

func update(update_name: String, update_args:Dictionary) -> void:
	match update_name:
		"change_execution_type":
			change_execution_type(update_args)
		_:
			pass
	print_debug("Update: ", update_name)


func change_execution_type(args:Dictionary) -> void:
	match args["type"]:
		action_types.always_active:
			action_type = action_types.always_active
		action_types.proc_chance_based:
			action_proc_chance = args["proc_chance"]
			action_type = action_types.proc_chance_based
		action_types.interval_based:
			action_interval = args["interval"]
			action_type = action_types.interval_based
		action_types.cooldown_based:
			action_cooldown = args["cooldown"]
			action_type = action_types.cooldown_based
		_:
			pass
