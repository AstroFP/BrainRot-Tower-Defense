class_name HungryHippo
extends CharacterBody2D

@onready var path_follow = $".."

@export var move_speed := 75.0

var rng = RandomNumberGenerator.new()

func _ready():
	var random_pos_offset = rng.randf_range(-100,100)
	position = Vector2(0,random_pos_offset)
	
func _physics_process(delta): 
	path_follow.progress += move_speed * delta
	
