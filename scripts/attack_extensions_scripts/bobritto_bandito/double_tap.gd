@tool
class_name DoubleTap 
extends BasicAction


var double_tap_delay : float = 0.1
var triple_tap_delay : float = double_tap_delay / 2.0


func _init() -> void:
	resource_name = "double_tap"
	action_function = double_tap
	updates = ["none", "crit_double_tap"]


func double_tap(params:Dictionary) -> void:
	await params["origin"].get_tree().create_timer(double_tap_delay).timeout
	params["origin"].basic_attack.attack(params)
	print_debug("double tapped for: ",params["damage"])


func triple_tap(params:Dictionary) -> void:
	await params["origin"].get_tree().create_timer(triple_tap_delay).timeout
	params["origin"].basic_attack.attack(params)
	await params["origin"].get_tree().create_timer(triple_tap_delay).timeout
	params["origin"].basic_attack.attack(params)
	print_debug("tripple tapped for: ",params["damage"])


func double_tap_crit_enhanced(params:Dictionary) -> void:
	print_debug("enhanced double tap")
	if params["is_crit"]:
		triple_tap(params)
	else:
		double_tap(params)


func update(update_name: String) -> void:
	match update_name.to_snake_case():
		"crit_double_tap":
			action_function = double_tap_crit_enhanced
		_:
			pass
