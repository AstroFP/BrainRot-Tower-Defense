@tool
class_name BasicAttackChanger
extends Resource

var changer_function:Callable
var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init() -> void:
	resource_name = "basic_attack_changer"
	changer_function = attack


func set_attack_changer(changer_func:Callable) -> void:
	changer_function = changer_func


func execute(params:Dictionary) -> void:
		changer_function.call(params)


func attack(params:Dictionary) -> void:
	print_debug("Attack changed")
	var current_target_hm = params["target"].get_node("HealthManager")
	current_target_hm.take_damage(params["damage"])
	for enhancement in params["origin"].attack_enhancements:
		params["origin"].attack_enhancements[enhancement].apply(params)

func update(update_name: String) -> void:
	print_debug("Update: ", update_name)
