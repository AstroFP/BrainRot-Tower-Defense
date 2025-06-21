class_name GameManager
extends Node2D

# array of paths on the level
var paths: Array

# load wave info
var wave_info := WaveInfo.new()

# set wave info to local vars
var waves = wave_info.waves
var current_wave = wave_info.current_wave
var max_waves = wave_info.max_waves

# boolean flags for wave management
var wave_in_progress = false
var all_paths_empty = true
var wave_spawning_in_progress = false

func _ready():
	paths = [get_node("../Path")]
	
	
func _physics_process(delta):
	if current_wave <= max_waves:
		if Input.is_action_pressed("play"):
			if !wave_in_progress:
				spawn_wave(paths[0],current_wave-1)
				current_wave += 1
				
	for path in paths:  
		if path.get_child_count() > 0:
			all_paths_empty = false
			break
		else:
			if path == paths[len(paths) - 1]:   
				all_paths_empty = true
	
	if all_paths_empty && !wave_spawning_in_progress:
		wave_in_progress = false
		
	

func spawn_wave(path,wave_num):
	wave_in_progress = true
	wave_spawning_in_progress = true
	var patterns = unpack_enemies_pattern(waves[wave_num])
	
	for pattern in patterns:
		for batch in pattern:
			for enemy_number in batch[0]:
				var enemy_to_spawn = wave_info.enemies[batch[1]].instantiate()
				path.add_child(enemy_to_spawn)
				await get_tree().create_timer(waves[wave_num]["enemy_spawn_delay"]).timeout
		await get_tree().create_timer(waves[wave_num]["enemy_pattern_spawn_delay"]).timeout
	
	wave_spawning_in_progress = false

func unpack_enemies_pattern(wave):
	var enemies_patterns_list = wave['enemies_pattern'].split("_")
	var patterns = [] # [((),(),...),...]
	for pattern in enemies_patterns_list:
		patterns.append([])
		var enemies_patterns = pattern.split(".")
		for enemy_pattern in enemies_patterns:
			var number = int(enemy_pattern.substr(0,enemy_pattern.length() - 1))
			var type = enemy_pattern.substr(enemy_pattern.length() - 1, 1) 
			patterns[len(patterns)-1].append([number,type])
		
	return patterns
