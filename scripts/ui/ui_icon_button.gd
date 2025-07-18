class_name UIIconButton
extends UIButton

@export var btn_icon: Texture2D
@export var flip_h:= false
@export var flip_v:= false

@onready var button_icon = $GradientWrapper/InnerWrapper/InnerColor/ButtonIcon


func _ready():
	super()
	button_icon.texture = btn_icon
	button_icon.flip_h = flip_h
	button_icon.flip_v = flip_v

func _process(_delta):
	pass


func set_default_style():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color)


func set_disabled_style():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color_disabled)
