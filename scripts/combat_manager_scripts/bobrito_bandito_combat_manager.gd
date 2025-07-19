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

### Combat functions

# copy of basic attack for debug
func additional_attack_hitscan() -> void:
	update_target()
	if current_target:
		var current_target_hm = current_target.get_node("HealthManager")
		current_target_hm.take_damage(tower.get_total_attack_damage())
		#print("additional_attack")

### Combat classes
class SpecialAttack:
	func _init() -> void:
		pass
	# every apply should take dictionary params as argument
	# apply should call a dedicated function e.g. explode()
	func apply(params:Dictionary) -> void:
		print("Target: {tar} received {dmg} damage.".format({"tar":params["target"],"dmg":params["damage"]}))


class DoubleTap:
	func _init() -> void:
		pass
	
	
	func apply(params:Dictionary) -> void:
		double_tap(params["origin"])
	
	
	func double_tap(origin:BasicCombatManager) -> void:
		await origin.get_tree().create_timer(0.1).timeout
		origin.basic_attack_hitscan()
		print("double_tapped")


class AdditionalAttack extends BasicExtraAttack:
	func _init(att_delay: float, att_func: Callable) -> void:
		super(att_delay, att_func)


class AttackReplacer extends BasicAttackReplacer:
	pass
