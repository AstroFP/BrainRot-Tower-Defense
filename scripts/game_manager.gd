class_name GameManager
extends Node2D

const PATH_FOLLOW = preload("res://prefabs/enemies/path_follow.tscn")
#@onready var path = $"../Path"
var paths

var wave_info := WaveInfo.new()

var waves = wave_info.waves
var current_wave = wave_info.current_wave
var max_waves = wave_info.max_waves

func _ready():
	paths = [get_node("../Path")]
	#var hungry_hippo = PATH_FOLLOW.instantiate()
	#hungry_hippo.get_node("HungryHippo").move_speed = 200.0
	#path.add_child(hungry_hippo)
	#spawn_enemies()
	spawn_wave(paths[0],current_wave-1)
	
func _physics_process(delta):
	pass

func spawn_enemies():
	for i in range(5):
		paths[0].add_child(PATH_FOLLOW.instantiate())
		await get_tree().create_timer(0.5).timeout


func spawn_wave(path,wave_num):
	var patterns = unpack_enemies_pattern(waves[wave_num])
	
	for pattern in patterns:
		for enemy_number in pattern[0]:
			var enemy_to_spawn = wave_info.enemies[pattern[1]].instantiate()
			path.add_child(enemy_to_spawn)
			await get_tree().create_timer(waves[wave_num]["enemy_spawn_delay"]).timeout
		await get_tree().create_timer(waves[wave_num]["enemy_pattern_spawn_delay"]).timeout


func unpack_enemies_pattern(wave):
	var enemies_patterns_list = wave['enemies_pattern'].split("_")
	var patterns = []
	for pattern in enemies_patterns_list:
		var number = int(pattern.substr(0,pattern.length() - 1))
		var type = pattern.substr(pattern.length() - 1, 1)
		patterns.append([number,type])
		
	return patterns
