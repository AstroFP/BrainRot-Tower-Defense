class_name UIButton
extends Button

@export var btn_style: UIButtonStyle
@export var btn_text: String
@export var btn_icon: Texture2D

@onready var gradient_border = $GradientWrapper/GradientBorder
@onready var inner_color = $GradientWrapper/InnerWrapper/InnerColor
@onready var label = $GradientWrapper/InnerWrapper/InnerColor/Label

var inner_color_stylebox: StyleBoxFlat
var gradient_border_stylebox: StyleBoxFlat


func _ready():
	if !btn_style:
		btn_style = UIButtonStyle.new()


	label.text = btn_text
	
	# initialize style variables
	inner_color_stylebox = inner_color.get("theme_override_styles/panel") as StyleBoxFlat
	gradient_border_stylebox = gradient_border.get("theme_override_styles/panel") as StyleBoxFlat
	
	# setup button
	enable_button()
	

func _process(delta):
	pass


func enable_button():
	disabled = false
	inner_color_stylebox.bg_color = btn_style.inner_color
	gradient_border_stylebox.bg_color = btn_style.gradient_border_color_top
	gradient_border_stylebox.border_color = btn_style.gradient_border_color_bottom
	label.add_theme_color_override("font_color",btn_style.font_color)


func disable_button():
	disabled = true
	inner_color_stylebox.bg_color = btn_style.inner_color_disabled
	gradient_border_stylebox.bg_color = btn_style.gradient_border_color_top_disabled
	gradient_border_stylebox.border_color = btn_style.gradient_border_color_bottom_disabled
	label.add_theme_color_override("font_color",btn_style.font_color_disabled)
	
	
func _on_pressed():
	disable_button()
	print_debug("button_pressed")
