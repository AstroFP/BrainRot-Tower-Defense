class_name BobrittoCombatManager
extends BasicCombatManager


func _ready() -> void:
	super()
	# set default attack the tower can get back to on attack changer deletion
	default_attack.default_attack_function = hitscan
	
	# set default attack
	default_attack.change_attack_function(hitscan)
	

func _process(delta: float) -> void:
	super(delta)
