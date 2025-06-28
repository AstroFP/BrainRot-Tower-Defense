extends Node2D

var detection_range
var tower_stats : TowerStats
var tower

var enemies_in_range := []
#var targetting_style
#var current_target

func _ready() -> void:
	tower = get_parent()
	tower_stats = tower.tower_stats
	detection_range = tower.get_node("AttackRange")
	
	#parsing the current enemies in range
	parse_initial_enemies_in_range(detection_range.get_overlapping_bodies())
	
	#connecting to signals
	#body entered/exited will be used to update the enemies_in_range array
	detection_range.body_entered.connect(_on_body_entered)
	detection_range.body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func parse_initial_enemies_in_range(overlapping_bodies):
	for body in overlapping_bodies:
		if body is HungryHippo:
			enemies_in_range.append(body)


func _on_body_entered(body):
	if body is HungryHippo:
		enemies_in_range.append(body)


#this should handle bodies that get freed(), aka when body will be dead
#note: may need a custom signal for death in case we need to animate death which could cause latency issues
func _on_body_exited(body):
	if body is HungryHippo:
		enemies_in_range.erase(body)


func update_target():
	pass
	#match targetting_style:
		#"first":
			#pass
		#_:
			#pass
