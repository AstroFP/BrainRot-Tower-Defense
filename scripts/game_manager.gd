class_name GameManager
extends Node

@export var game_rules: GameRules

# array of paths on the level
var paths: Array

# load wave info
var wave_info := WaveInfo.new()

# set wave info to local vars
var waves = wave_info.waves
var current_wave: int
var max_waves: int

# boolean flags for wave management
var wave_in_progress = false
var all_paths_empty = true
var wave_spawning_in_progress = false

var rng := RandomNumberGenerator.new()

# ui
var ui_scene = preload("res://scenes/ui/ui.tscn")
var ui: UIManager

# tower placement manager
var tower_placement_manager_component = preload("res://scenes/tower_placement_manager.tscn")
var tower_placement_manager : TowerPlacementManager

# level resources
var level_resources : = LevelResources.new()


func _ready():
	# if the scene was reloaded unpause it
	unpause_game()
	
	for path in get_parent().get_children():
		if is_instance_of(path, Path2D):
			paths.append(path)
	
	if paths.is_empty():
		printerr("No paths set on the level!")
		
	# setup process mode
	process_mode = Node.PROCESS_MODE_ALWAYS

	# setup the game level
	current_wave = game_rules.start_wave - 1
	max_waves = game_rules.last_wave
	setup_game_level()
	
	# setup starting resources
	level_resources.current_lives = game_rules.starting_lives
	level_resources.current_cash = game_rules.starting_cash
	level_resources.connect("game_over",_on_game_over)
	
	
func _process(_delta):
	# check if wave in progress
	for path in paths:   
		if path.get_child_count() > 1:
			all_paths_empty = false
			break
		else:
			if path == paths[len(paths) - 1]:   
				all_paths_empty = true
	
	if all_paths_empty && !wave_spawning_in_progress:
		wave_in_progress = false
		ui.change_play_btn_icon_to_play()
		
	if Input.is_action_just_pressed("add_cash"): # d
		level_resources.update_current_cash(100)
		ui.resources_panel.update_money_count(level_resources.current_cash)
	
	if Input.is_action_just_pressed("add_lives"): # o
		level_resources.update_current_lives(10)
		ui.update_health_count(level_resources.current_lives)
	
	if Input.is_action_just_pressed("sub_lives"): # p
		level_resources.update_current_lives(-10)
		ui.update_health_count(level_resources.current_lives)
	
	
func spawn_wave(wave_num):
	wave_in_progress = true
	wave_spawning_in_progress = true
	var patterns = unpack_enemies_pattern(waves[wave_num])
	
	for pattern in patterns:
		for batch in pattern:
			for enemy_number in batch[0]:
				var enemy_to_spawn = wave_info.enemies[batch[1]].instantiate()
				# for now its random but should be changed to be predefined in the future
				var random_path_idx = rng.randi_range(0,len(paths)-1)
				
				# connect enemy end of track signal
				# get_child(0) - because hippo emit signal and is first (idx=0) child of path follow
				enemy_to_spawn.get_child(0).connect("end_of_track_reached",_on_enemy_end_of_track_reached)
				
				paths[random_path_idx].add_child(enemy_to_spawn)
				
				await get_tree().create_timer(waves[wave_num]["enemy_spawn_delay"]).timeout
			await get_tree().create_timer(waves[wave_num]["enemy_batch_spawn_delay"]).timeout
		await get_tree().create_timer(waves[wave_num]["enemy_pattern_spawn_delay"]).timeout
	
	wave_spawning_in_progress = false


func unpack_enemies_pattern(wave):
	var enemies_patterns_list = wave['enemies_pattern'].split("_")
	var patterns = [] # [((),(),...),...]
	for pattern in enemies_patterns_list:
		patterns.append([])
		var enemies_patterns = pattern.split(".")
		for enemy_pattern in enemies_patterns:
			var enemy_number = int(enemy_pattern.substr(0,enemy_pattern.length() - 1))
			var type = enemy_pattern.substr(enemy_pattern.length() - 1, 1) 
			patterns[len(patterns)-1].append([enemy_number,type])
		
	return patterns


func setup_ui():
	ui = ui_scene.instantiate()
	ui.game_rules = game_rules
	ui.connect("play_btn_pressed",_on_play_btn_pressed)
	ui.connect("pause_game",_on_game_pause)
	ui.connect("unpause_game",_on_game_unpause)
	add_child(ui)
	
	ui.update_wave_display(game_rules.start_wave)	


func setup_tower_placement_manager():
	tower_placement_manager = tower_placement_manager_component.instantiate()
	tower_placement_manager.ui = ui
	tower_placement_manager.connect("selected_tower_placed",_on_selected_tower_placed)
	add_child(tower_placement_manager)


func setup_game_level():
	setup_ui()
	setup_tower_placement_manager()
 

func pause_game():
	# disable game loops in game manager
	set_process(false)
	set_physics_process(false)
	 
	# pause the game
	get_tree().paused = true 


func unpause_game():
	# enable game loops in game manager
	set_process(true)
	set_physics_process(true)
	
	# unpause the game
	get_tree().paused = false


# signal handlers

# substract money on tower placed
func _on_selected_tower_placed(tower: TowerStats):
	level_resources.update_current_cash(-tower.price)
	ui.update_money_count(level_resources.current_cash)

# substract health on enemy reached end of track
func _on_enemy_end_of_track_reached(damage:int):
	level_resources.update_current_lives(-damage)
	ui.update_health_count(level_resources.current_lives)

# handle game over
func _on_game_over():
	ui.show_game_over_panel(current_wave)
	ui.toggle_paused_background_overlay()
	pause_game()


func _on_play_btn_pressed():
	if current_wave < max_waves:
			if !wave_in_progress:
				ui.change_play_btn_icon_to_fast_forward()
				spawn_wave(current_wave)
				current_wave += 1
				ui.update_wave_display(current_wave)


func _on_game_pause():
	pause_game()


func _on_game_unpause():
	await get_tree().create_timer(0.5).timeout
	unpause_game()
