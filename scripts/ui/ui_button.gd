class_name UIButton
extends Button

@export var btn_style: UIButtonStyle
@export var start_disabled:= false

var gradient_border: PanelContainer
var inner_color: PanelContainer
var inner_color_stylebox: StyleBoxFlat


func _ready():
	# if no styling provided - create new (defaults to gray button style)
	if !btn_style:
		btn_style = UIButtonStyle.new()
	
	# connect down and up signals for styling
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	# find and set border and inner background
	gradient_border = find_child("GradientBorder")
	inner_color = find_child("InnerColor")
	
	# initialize style variables
	inner_color_stylebox = inner_color.get("theme_override_styles/panel") as StyleBoxFlat
	
	# setup button
	disabled = start_disabled
	if disabled:
		disable_button()
	else:
		enable_button()


func _process(_delta):
	pass


func enable_button():
	disabled = false
	set_default_style()


func disable_button():
	disabled = true
	set_disabled_style()


func set_pressed_style():
	inner_color_stylebox.bg_color = btn_style.inner_color_pressed
	gradient_border.material.set_shader_parameter("color_top",btn_style.gradient_border_color_top_pressed)
	gradient_border.material.set_shader_parameter("color_bottom",btn_style.gradient_border_color_bottom_pressed)


func set_default_style():
	inner_color_stylebox.bg_color = btn_style.inner_color
	gradient_border.material.set_shader_parameter("color_top",btn_style.gradient_border_color_top)
	gradient_border.material.set_shader_parameter("color_bottom",btn_style.gradient_border_color_bottom)


func set_disabled_style():
	inner_color_stylebox.bg_color = btn_style.inner_color_disabled
	gradient_border.material.set_shader_parameter("color_top",btn_style.gradient_border_color_top_disabled)
	gradient_border.material.set_shader_parameter("color_bottom",btn_style.gradient_border_color_bottom_disabled)


func _on_button_down():
	set_pressed_style()


func _on_button_up():
	set_default_style()
