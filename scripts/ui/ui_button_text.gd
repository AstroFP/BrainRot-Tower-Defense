class_name UIButtonText
extends UIButton

@export var btn_text: String

@onready var label = $GradientWrapper/InnerWrapper/InnerColor/Label


func _ready():
	super()
	label.text = btn_text


func _process(_delta):
	pass


func enable_button():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color)


func disable_button():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color_disabled)


func set_btn_text(text:String):
	label.text = text
