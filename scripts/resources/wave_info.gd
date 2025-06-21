class_name WaveInfo
extends Resource

const HUNGRY_HIPPO = preload("res://prefabs/enemies/path_follow.tscn")

@export var enemies := {
	"H":HUNGRY_HIPPO
}

@export var waves := [
	{
		"wave_number":1,
		"enemies_pattern":"3H_8H",
		"enemy_spawn_delay":0.5,
		"enemy_pattern_spawn_delay":5.0
	}
]

@export var current_wave := 1
var max_waves := len(waves)
