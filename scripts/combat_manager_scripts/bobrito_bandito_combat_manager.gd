class_name BobrittoCombatManager
extends BasicCombatManager


func _ready() -> void:
	super()


func _process(delta: float) -> void:
	super(delta)


# ---Functions returning objects by string name---

func _get_inner_action_class(inner_class_name: String):
	match inner_class_name:
		"double_tap":
			return DoubleTap.new()
		_:
			return


func _get_inner_extra_attack_class(inner_class_name:String, att_delay: float):
	match inner_class_name:
		"additional_attack":
			return AdditionalAttack.new(att_delay)
		_:
			return


func _get_inner_attack_replacer_class(inner_class_name: String, interval: int):
	match  inner_class_name:
		"additional_attack":
			return TMPAttackReplacer.new(interval)
		_:
			return


func _get_inner_attack_enhancement_class(inner_class_name:String):
	match  inner_class_name:
		"attack_enhancement":
			return TMPAttackEnhancement.new(20)
		_:
			return

# ---Combat functions---





# ---Combat classes---

class SpecialAttack extends BasicAction:
	#var enhancement: AttackEnhancement
	func _init() -> void:
		#enhancement = AttackEnhancement.new(200)
		pass

	func apply(params:Dictionary) -> void:
		print("Target: {tar} received {dmg} damage.".format({"tar":params["target"],"dmg":params["damage"]}))
		#enhancement.apply(params)


class DoubleTap extends BasicAction:
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
			"double_tap_crit_enhanced":
				action_function = double_tap_crit_enhanced
			_:
				pass


class AdditionalAttack extends BasicExtraAttack:
	func _init(att_delay: float) -> void:
		attack_delay = att_delay
		attack_timer = 0
		attack_function = additional_attack_hitscan
		
	# copy of basic attack for debug
	func additional_attack_hitscan(params:Dictionary) -> void:
		var current_target_hm = params["target"].get_node("HealthManager")
		current_target_hm.take_damage(params["damage"])

class TMPAttackReplacer extends BasicAttackReplacer:
	func _init(att_interval: int) -> void:
		attack_interval = att_interval
		attack_function = additional_attack_hitscan
	# copy of basic attack for debug
	func additional_attack_hitscan(params:Dictionary) -> void:
		var current_target_hm = params["target"].get_node("HealthManager")
		current_target_hm.take_damage(params["damage"])


class TMPAttackEnhancement extends BasicAttackEnhancement:
	func _init(dmg: float) -> void:
		enhancement_damage = dmg
