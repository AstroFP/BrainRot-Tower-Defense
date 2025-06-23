extends Node2D

var max_health := 200
var min_health := 0
var current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health *0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
