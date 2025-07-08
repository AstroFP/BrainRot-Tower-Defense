class_name UIIconButton
extends UIButton

@export var btn_icon: Texture2D

@onready var button_icon = $GradientWrapper/InnerWrapper/InnerColor/ButtonIcon


func _ready():
	super()
	button_icon.texture = btn_icon


func _process(_delta):
	pass


func enable_button():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color)


func disable_button():
	super()
	button_icon.material.set_shader_parameter("color", btn_style.font_color_disabled)
