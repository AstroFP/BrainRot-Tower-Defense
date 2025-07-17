class_name UpgradesManager
extends Node

var tower: Tower
var upgrades : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower = get_parent()
	aplly_upgrade(tower.tower_stats.tower_upgrades.upgrades["paths"]["path_2"]["upgrades"][0])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func aplly_upgrade(upgrade:Dictionary) -> void:
	aplly_effects(upgrade["effects"])


func aplly_effects(effects : Dictionary) -> void:
	for effect_name in effects:
		match effect_name:
			"attack_speed_multiplier":
				tower.attack_speed_multiplier +=  effects[effect_name]
			"attack_damage_multiplier":
				tower.attack_damage_multiplier += effects[effect_name]
			"attack_radius_multiplier":
				tower.attack_radius_multiplier += effects[effect_name]
			"attack_damage":
				tower.attack_damage += effects[effect_name]
			"attack_speed":
				tower.attack_speed += effects[effect_name]
			"attack_radius":
				tower.attack_radius += effects[effect_name]
			_:
				pass

func apply_actions() -> void:
	pass
