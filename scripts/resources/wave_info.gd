class_name WaveInfo
extends Resource

const HUNGRY_HIPPO = preload("res://prefabs/enemies/path_follow.tscn")

@export var enemies := {
	"H":HUNGRY_HIPPO
}

@export var waves := [
	{
		"wave_number":1,
		"enemies_pattern":"1H_2H_3H",
		"enemy_spawn_delay":0.5,
		"enemy_batch_spawn_delay":0.0,
		"enemy_pattern_spawn_delay":5.0
	},
	{
		"wave_number":2,
		"enemies_pattern":"4H_8H",
		"enemy_spawn_delay":0.5,
		"enemy_batch_spawn_delay":0.0,
		"enemy_pattern_spawn_delay":3.0
	},
	{  
		"wave_number":3,
		"enemies_pattern":"1H.2H.1H.1H.1H",
		"enemy_spawn_delay":0.5,
		"enemy_batch_spawn_delay":1.0,
		"enemy_pattern_spawn_delay":0.0
	},
]

@export var current_wave := 0
var max_waves := len(waves)
