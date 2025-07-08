class_name PlayButton
extends Button

const PLAY_ICON = preload("res://assets/sprites/ui/right_menu/play_icon.png")
const FAST_FORWARD_ICON = preload("res://assets/sprites/ui/right_menu/fast_forward_icon.png")


func _ready():
	icon = PLAY_ICON


func _process(_delta):
	pass


func change_icon_to_play():
	icon = PLAY_ICON


func change_icon_to_fast_forwad():
	icon = FAST_FORWARD_ICON
