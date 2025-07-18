class_name BasicCombatManager
extends Node2D

var detection_area : Area2D
var enemies_in_range := []
var enemies_in_range_path_progressions := []
var tower_stats : TowerStats
var tower : Tower

enum targetting_styles{
	first,
	last,
	close
}
var current_targetting_style := targetting_styles.first
var current_target


func _ready() -> void:
	tower = get_parent()
	tower_stats = tower.tower_stats
	detection_area = tower.get_node("AttackRange")
	
	#parsing the current enemies in range
	parse_initial_enemies_in_range(detection_area.get_overlapping_bodies())
	
	#connecting to signals
	#body entered/exited are used to update the enemies_in_range array
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

var attack_cooldown : float = 0
func _process(delta: float) -> void:
	attack_cooldown += delta
	
	#happens every 60s / tower attack speed
	if attack_cooldown > tower.get_attack_delay():
		#print_debug(enemies_in_range.size())
		attack()
		attack_cooldown = 0.0


#				!---- Section 1----!
# !----handling updating enemies_in_range array---!
func parse_initial_enemies_in_range(overlapping_bodies):
	for body in overlapping_bodies:
		if body is HungryHippo:
			enemies_in_range.append(body)
			body.get_node("HealthManager").dead.connect(_on_enemy_dead)


func _on_body_entered(body):
	if body is HungryHippo:
		enemies_in_range.append(body)
		body.get_node("HealthManager").dead.connect(_on_enemy_dead)


#this should handle bodies that get freed(), aka when body will be dead
#note: may need a custom signal for death in case we need to animate death which could cause latency issues
func _on_body_exited(body):
	if body is HungryHippo:
		enemies_in_range.erase(body)
		body.get_node("HealthManager").dead.disconnect(_on_enemy_dead)

func _on_enemy_dead(body):
	if body is HungryHippo:
		enemies_in_range.erase(body)


#			!---- Section 2----!
#!---- choosing a current tower target ----!

#the default targetting style is 'first', call this to change the current_targetting_style
#buttons in tower gui will be calling this most likely
func change_current_targetting_style(new_targetting_style : targetting_styles):
	current_targetting_style = new_targetting_style

#based on current_targetting_style chooses a correct target
func update_target():
	match current_targetting_style:
		targetting_styles.first:
			current_target = choose_first_enemy()
		targetting_styles.last:
			current_target = choose_last_enemy()
		targetting_styles.close:
			current_target = choose_closest_enemy()
		_:
			printerr("impossible targetting style is set")


func choose_first_enemy() -> HungryHippo:
	var first_enemy : HungryHippo = null
	var max_progress: float = -INF
	var progress
	
	for enemy in enemies_in_range:
		progress = enemy.get_parent().progress
		if progress > max_progress:
			max_progress = progress
			first_enemy = enemy
	
	return first_enemy


func choose_last_enemy() -> HungryHippo:
	var last_enemy : HungryHippo = null
	var min_progress: float = INF
	var progress
	
	for enemy in enemies_in_range:
		progress = enemy.get_parent().progress
		if progress < min_progress:
			min_progress = progress
			last_enemy = enemy
	return last_enemy


func choose_closest_enemy() -> HungryHippo:
	var closest_enemy : HungryHippo = null
	var min_distance: float = INF
	var distance
	
	for enemy in enemies_in_range:
		distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

#	  !---- Section 3----!
#!---- Actual Combat functionalities ----!


var actions : Array = [] # array of special actions gained from upgrades
var attack_enhancements : Array = []
var attack_params : Dictionary = {
	"origin":self,
	"target":null,
	"damage":0
}

func basic_attack_hitscan() -> void:
	update_target()
	if current_target:
		var current_target_hm = current_target.get_node("HealthManager")
		current_target_hm.take_damage(tower.get_total_attack_damage())


func attack():
	if !enemies_in_range.is_empty():
		# perform attack with or without speial enhacments
		basic_attack_hitscan()
		
		# perform additional acions
		for action in actions:
			attack_params["target"] = current_target
			attack_params["damage"] = tower.get_total_attack_damage()
			action.apply(attack_params)
