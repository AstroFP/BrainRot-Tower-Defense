class_name GameManager
extends Node2D

const PATH_FOLLOW = preload("res://prefabs/enemies/path_follow.tscn")
#@onready var path = $"../Path"
var path

func _ready():
	path = get_node("../Path")
	var hungry_hippo = PATH_FOLLOW.instantiate()
	hungry_hippo.get_node("HungryHippo").move_speed = 200.0
	path.add_child(hungry_hippo)
	path.add_child(PATH_FOLLOW.instantiate())
	
func _physics_process(delta):
	pass
