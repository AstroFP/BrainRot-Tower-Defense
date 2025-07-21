class_name DoubleTap 
extends BasicAction



func _init() -> void:
	action_function = double_tap
	
	
func double_tap(params:Dictionary) -> void:
	await params["origin"].get_tree().create_timer(0.1).timeout
	params["origin"].basic_attack.attack(params)
	print_debug("double tapped for: ",params["damage"])
	
func triple_tap(params:Dictionary) -> void:
	await params["origin"].get_tree().create_timer(0.05).timeout
	params["origin"].basic_attack.attack(params)
	await params["origin"].get_tree().create_timer(0.05).timeout
	params["origin"].basic_attack.attack(params)
	
	
func double_tap_crit_enhanced(params:Dictionary) -> void:
	print_debug("enhanced double tap")
	if params["is_crit"]:
		triple_tap(params)
	else:
		double_tap(params)


func update(update_name: String) -> void:
	match update_name:
		"crit_double_tap":
			action_function = double_tap_crit_enhanced
		_:
			pass
