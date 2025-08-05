class_name UIButtonText
extends UIButton

@export var btn_text: String
@export var font_size: int

@onready var label = $GradientWrapper/InnerWrapper/InnerColor/Label


func _ready():
	super()
	label.text = btn_text
	if font_size:
		label.add_theme_font_size_override("font_size",font_size)


func _process(_delta):
	pass


func set_default_style():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color)


func set_disabled_style():
	super()
	label.add_theme_color_override("font_color",btn_style.font_color_disabled)


func set_btn_text(_text:String):
	label.text = _text
