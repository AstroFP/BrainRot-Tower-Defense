class_name PlayButton
extends Button

const PLAY_ICON = preload("res://assets/sprites/ui/play_icon.png")
const FAST_FORWARD_ICON = preload("res://assets/sprites/ui/fast_forward_icon.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = PLAY_ICON


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func change_icon_to_play():
	icon = PLAY_ICON


func change_icon_to_fast_forwad():
	icon = FAST_FORWARD_ICON
