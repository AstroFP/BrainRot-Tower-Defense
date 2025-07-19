extends BasicCombatManager


func _ready() -> void:
	super()


func _process(delta: float) -> void:
	super(delta)


func _get_inner_action_class(inner_class_name: String):
	match inner_class_name:
		"special_attack":
			return SpecialAttack.new()
		"double_tap":
			return DoubleTap.new()
		_:
			return


func _get_inner_extra_attack_class(inner_class_name:String, att_delay: float):
	match inner_class_name:
		"additional_attack":
			return AdditionalAttack.new(att_delay, _get_attack_callable(inner_class_name))
		_:
			return


func _get_inner_attack_replacer_class(inner_class_name: String, interval: int):
	match  inner_class_name:
		"additional_attack":
			return AttackReplacer.new(interval,_get_attack_callable(inner_class_name))
		_:
			return

func _get_attack_callable(callable_name:String):
	match callable_name:
		"additional_attack":
			return additional_attack_hitscan
		_:
			return


func _get_inner_attack_enhancement_class(inner_class_name:String):
	match  inner_class_name:
		"attack_enhancement":
			return AttackEnhancement.new(20)
		_:
			return

### Combat functions

# copy of basic attack for debug
func additional_attack_hitscan(params:Dictionary) -> void:
	var current_target_hm = params["target"].get_node("HealthManager")
	current_target_hm.take_damage(params["damage"])


### Combat classes
class SpecialAttack:
	#var enhancement: AttackEnhancement
	func _init() -> void:
		#enhancement = AttackEnhancement.new(200)
		pass

	func apply(params:Dictionary) -> void:
		print("Target: {tar} received {dmg} damage.".format({"tar":params["target"],"dmg":params["damage"]}))
		#enhancement.apply(params)


class DoubleTap:
	func _init() -> void:
		pass
	
	
	func apply(params:Dictionary) -> void:
		double_tap(params)
	
	
	func double_tap(params:Dictionary) -> void:
		await params["origin"].get_tree().create_timer(0.1).timeout
		params["origin"].basic_attack.attack(params)
		print("double_tapped for: ", params["damage"])


class AdditionalAttack extends BasicExtraAttack:
	func _init(att_delay: float, att_func: Callable) -> void:
		super(att_delay, att_func)


class AttackReplacer extends BasicAttackReplacer:
	pass


class AttackEnhancement extends BasicAttackEnhancement:
	func _init(dmg: float) -> void:
		damage = dmg
