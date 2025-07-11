class_name PlayButton
extends UIButton

const PLAY_ICON = preload("res://assets/sprites/ui/right_menu/play_icon.png")
const FAST_FORWARD_ICON = preload("res://assets/sprites/ui/right_menu/fast_forward_icon.png")

@onready var button_icon = $GradientWrapper/InnerWrapper/InnerColor/ButtonIcon

func _ready():
	super()
	button_icon.texture = PLAY_ICON
	

func _process(_delta):
	pass


func change_icon_to_play():
	button_icon.texture = PLAY_ICON


func change_icon_to_fast_forwad():
	button_icon.texture = FAST_FORWARD_ICON


func set_default_style():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color)


func set_disabled_style():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color_disabled)
