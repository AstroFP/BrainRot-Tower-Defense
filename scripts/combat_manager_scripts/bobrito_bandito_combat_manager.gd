class_name BobrittoCombatManager
extends BasicCombatManager


func _ready() -> void:
	super()
	# set default attack (for now use basic hitscan)
	default_attack.change_attack_function(BasicHitscanAttack.attack)


func _process(delta: float) -> void:
	super(delta)
