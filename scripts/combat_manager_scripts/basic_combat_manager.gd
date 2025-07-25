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
var default_attack: DefaultAttack

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
	
	# set basic attack
	default_attack = DefaultAttack.new(hitscan)
	
	

var attack_cooldown : float = 0
func _process(delta: float) -> void:
	attack(delta)

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

# dictionary of special actions gained from upgrades
var attack_actions : Dictionary[String,BasicAttackAction] = {} 

# dictionary of extra attacks with separate cooldowns gained from upgrades
var extra_attacks: Dictionary[String,BasicExtraAttack] = {}

# dictionary of attack enhancements gained from upgrades
var attack_enhancements : Dictionary[String,BasicAttackEnhancement] = {}

# dictionary of attack replacers gained from upgrades
var attack_replacers : Dictionary[String,BasicAttackReplacer] = {}

# attack changer gained from upgrades
var attack_changer : BasicAttackChanger:
	set(value):
		attack_changer = value
		default_attack.change_attack_function(attack_changer.attack)

# attack parameters required by combat functions
var attack_params : Dictionary = {
	"origin":self,
	"target":null,
	"damage":0,
	"is_crit":false
}

# attack funcion that encapsulates the new attack logic supporting upgrade functionality
func attack(delta_time: float):
	# return if no enemies in range
	if enemies_in_range.is_empty():
		return
	
	# select next target
	update_target()
	
	# return if target no longer exists
	if !current_target:
		return 
	
	# set crucial attack parameters
	attack_params["target"] = current_target
	attack_params["damage"] = tower.get_total_attack_damage()
	
	# basic attack
	perform_basic_attack(delta_time)
	
	# additional attacks (independent, with separate cooldowns)
	perform_extra_attacks(delta_time)


func perform_basic_attack(delta_time: float) -> void:
	attack_cooldown += delta_time
	# happens every 60s / tower attack speed
	if attack_cooldown >= tower.get_attack_delay():
		# basic attack with attack replacers
		roll_for_crit()
		var attack_replaced = false
		for attack_replacer in attack_replacers:
			if attack_replacers[attack_replacer].should_replace(delta_time + tower.get_attack_delay()):
				attack_replacers[attack_replacer].execute(attack_params)
				attack_replaced = true
		if !attack_replaced:
			default_attack.attack(attack_params)
			for enhancement in attack_enhancements:
				if attack_enhancements[enhancement].should_enhance(delta_time + tower.get_attack_delay()):
					attack_enhancements[enhancement].apply(attack_params)
			print_debug("basic attack")
		
		# perform additional acions
		perform_actions(delta_time)
			
		attack_cooldown = 0.0


func perform_actions(delta_time) -> void:
	for action in attack_actions:
		if attack_actions[action].should_execute(delta_time):
			roll_for_crit()
			attack_actions[action].execute(attack_params)


func perform_extra_attacks(delta_time:float) -> void:
	for extra_attack in extra_attacks:
		if extra_attacks[extra_attack].should_execute(delta_time):
			roll_for_crit()
			extra_attacks[extra_attack].execute(attack_params)


func roll_for_crit():
	if is_critical_hit(tower.attack_crit_chance):
		attack_params["damage"] = tower.get_total_crit_damage()
		attack_params["is_crit"] = true
	else:
		attack_params["damage"] = tower.get_total_attack_damage()
		attack_params["is_crit"] = false


func is_critical_hit(crit_chance: float) -> bool:
	# ensure crit_chance stays between 0 and 100
	crit_chance = clamp(crit_chance, 0, 100)
	var roll = randf() * 100.0
	return roll < crit_chance


# class for default attack, it defines towers basic attack
# it also allows to change the default attack, should the default attack change via upgrades
class DefaultAttack:
	var attack_function: Callable
	var default_attack_function: Callable
	func _init(att_func:Callable) -> void:
		attack_function = att_func
	
	
	func attack(params:Dictionary):
		attack_function.call(params)
		
	
	func change_attack_function(new_att_func:Callable):
		attack_function = new_att_func


func hitscan(params:Dictionary) -> void:
	var current_target_hm = params["target"].get_node("HealthManager")
	current_target_hm.take_damage(params["damage"])

func spawn_projectile(params:Dictionary) -> void:
	pass
