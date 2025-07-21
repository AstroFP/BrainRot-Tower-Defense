class_name BasicHitscanAttack

func _init() -> void:
	pass


static func attack(params:Dictionary) -> void:
	var current_target_hm = params["target"].get_node("HealthManager")
	current_target_hm.take_damage(params["damage"])
	for enhancement in params["origin"].attack_enhancements:
		params["origin"].attack_enhancements[enhancement].apply(params)
