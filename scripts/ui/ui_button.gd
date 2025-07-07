class_name UIButton
extends Button

@export var btn_style: UIButtonStyle
@export var start_disabled:= false

#@onready var label = $GradientWrapper/InnerWrapper/InnerColor/Label

var gradient_border: PanelContainer
var inner_color: PanelContainer
var inner_color_stylebox: StyleBoxFlat
var gradient_border_stylebox: StyleBoxFlat


func _ready():
	if !btn_style:
		btn_style = UIButtonStyle.new()
	
	gradient_border = find_child("GradientBorder")
	inner_color = find_child("InnerColor")
	
	#label.text = btn_text
	
	# initialize style variables
	inner_color_stylebox = inner_color.get("theme_override_styles/panel") as StyleBoxFlat
	gradient_border_stylebox = gradient_border.get("theme_override_styles/panel") as StyleBoxFlat
	
	# setup button
	disabled = start_disabled
	if disabled:
		disable_button()
	else:
		enable_button()
	

func _process(delta):
	pass


func enable_button():
	disabled = false
	inner_color_stylebox.bg_color = btn_style.inner_color
	gradient_border_stylebox.bg_color = btn_style.gradient_border_color_top
	gradient_border_stylebox.border_color = btn_style.gradient_border_color_bottom
	#label.add_theme_color_override("font_color",btn_style.font_color)


func disable_button():
	disabled = true
	inner_color_stylebox.bg_color = btn_style.inner_color_disabled
	gradient_border_stylebox.bg_color = btn_style.gradient_border_color_top_disabled
	gradient_border_stylebox.border_color = btn_style.gradient_border_color_bottom_disabled
	#label.add_theme_color_override("font_color",btn_style.font_color_disabled)
