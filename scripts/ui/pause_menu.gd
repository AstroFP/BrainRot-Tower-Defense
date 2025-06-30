extends MarginContainer

signal pause_menu_opened
signal pause_menu_closed

@onready var pause_menu = $PauseMenu

var touch_start_time := 0.0
var holding := false
var hold_threshold := 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_time = Time.get_ticks_msec() / 1000.0
			holding = true
		else:
			var duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
			holding = false
			if duration < hold_threshold:
				if !pause_menu.get_global_rect().has_point(event.position):
						hide_pause_menu()
	
	
# Pause menu buttons pressed handling
func _on_continue_btn_pressed():
	hide_pause_menu()


func _on_play_again_btn_pressed():
	get_tree().reload_current_scene()


func show_pause_menu():
	emit_signal("pause_menu_opened")
	visible = true


func hide_pause_menu():
	emit_signal("pause_menu_closed")
	visible = false
