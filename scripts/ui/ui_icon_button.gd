class_name UIIconButton
extends UIButton

@export var btn_icon: Texture2D

@onready var button_icon = $GradientWrapper/InnerWrapper/InnerColor/ButtonIcon


func _ready():
	super()
	button_icon.texture = btn_icon


func _process(delta):
	pass


func enable_button():
	super()
	button_icon.material.set_shader_parameter("grayscale_amount", 0.0)


func disable_button():
	super()
	button_icon.material.set_shader_parameter("grayscale_amount", 0.9)
