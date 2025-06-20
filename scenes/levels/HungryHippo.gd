extends CharacterBody2D

@onready var remote_transform_2d = $"../Path/PathFollow/RemoteTransform2D"
@onready var path_follow = $"../Path/PathFollow"

@export var move_speed := 75.0

func _ready():
	#remote_transform_2d.remote_path = self.get_path()
	remote_transform_2d.position = Vector2(0,0)
	
	
func _physics_process(delta):
	path_follow.progress += move_speed * delta


