class_name HungryHippo
extends CharacterBody2D

@onready var path_follow = $".."

@export var move_speed := 75.0

func _ready():
	#remote_transform_2d.remote_path = self.get_path()
	position = Vector2(0,0)
	
func _physics_process(delta): 
	path_follow.progress += move_speed * delta
	
