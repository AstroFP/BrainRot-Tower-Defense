extends BasicCombatManager


func _ready() -> void:
	super()


func _process(delta: float) -> void:
	super(delta)


func get_inner_class(inner_class_name: String):
	match inner_class_name:
		"special_attack":
			return SpecialAttack.new()
		"double_tap":
			return DoubleTap.new()
		_:
			return null


class SpecialAttack:
	func _init() -> void:
		pass
	# every apply should take dictionary params as argument
	# apply should call a dedicated function e.g. explode()
	func apply(params:Dictionary) -> void:
		print("Target{tar} received {dmg} damage.".format({"tar":params["target"],"dmg":params["damage"]}))


class DoubleTap:
	func _init() -> void:
		pass
	
	
	func apply(params:Dictionary) -> void:
		double_tap(params["origin"])
	
	
	func double_tap(origin:BasicCombatManager) -> void:
		await origin.get_tree().create_timer(0.1).timeout
		origin.basic_attack_hitscan()
		print("double_tapped")
