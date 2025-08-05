@tool
class_name BasicExtraAttack
extends Resource


var attack_cooldown: float
var attack_timer: float
var attack_function: Callable

var updates: Array[String] = ["none", "change_cooldown"]

func _init() -> void:
	attack_timer = 0
	attack_function = basic_extra_attack
	resource_name = "basic_extra_attack"

func execute(params:Dictionary) -> void:
	attack_function.call(params)

func should_execute(delta_time:float) -> bool:
	attack_timer += delta_time
	if attack_timer >= attack_cooldown:
		attack_timer = 0
		return true
	return false


func update(update_name: String, update_args: Dictionary) -> void:
	match update_name:
		"change_cooldown":
			attack_cooldown = update_args["cooldown"]
		_:
			pass
			
	print_debug("Update: ", update_name)

func basic_extra_attack(params:Dictionary) -> void:
	print_debug("Extra attack: ",params["target"])
