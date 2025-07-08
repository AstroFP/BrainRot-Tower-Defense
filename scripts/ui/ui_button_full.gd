class_name UIButtonFull
extends UIButton

@export var btn_text: String
@export var btn_icon: Texture2D
@export var flip_h:= false
@export var flip_v:= false

@onready var label = $GradientWrapper/InnerWrapper/InnerColor/ButtonContent/Label
@onready var button_icon = $GradientWrapper/InnerWrapper/InnerColor/ButtonContent/ButtonIconWrapper/ButtonIcon


func _ready():
	super()
	label.text = btn_text
	button_icon.texture = btn_icon
	button_icon.flip_h = flip_h
	button_icon.flip_v = flip_v


func _process(_delta):
	pass


func enable_button():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color)
	button_icon.material.set_shader_parameter("color", btn_style.font_color)


func disable_button():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color_disabled)
	button_icon.material.set_shader_parameter("color", btn_style.font_color_disabled)
