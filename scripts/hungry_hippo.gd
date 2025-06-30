class_name HungryHippo
extends CharacterBody2D

signal end_of_track_reached(damage: int)

@onready var path_follow = $".."

# stats like move speed, health and damage should be in a resource e.g. EnemyStats/HippoStats
@export var move_speed := 75.0
var is_moving = true

var rng = RandomNumberGenerator.new()


func _ready():
	# setup process mode
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	var random_pos_offset = rng.randf_range(-100,100)
	position = Vector2(0,random_pos_offset)
	

func _physics_process(delta): 
	if is_moving == true:
		path_follow.progress += move_speed * delta
		if path_follow.progress_ratio >= 1.0:
			emit_signal("end_of_track_reached",1)
			get_parent().queue_free()
