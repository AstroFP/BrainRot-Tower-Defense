extends PanelContainer

signal popup_opened
signal popup_closed

@onready var cancel_btn = $PopupMenuContentsWrapper/PopupMenuContents/PopupMenuItems/PopupButtonsWrapper/PopupButtons/CancelBtn
@onready var ok_btn = $PopupMenuContentsWrapper/PopupMenuContents/PopupMenuItems/PopupButtonsWrapper/PopupButtons/OKBtn
@onready var popup_content_text = $PopupMenuContentsWrapper/PopupMenuContents/PopupMenuItems/PopupContentWrapper/PopupContent/PopupContentText
@onready var popup_header_text = $PopupMenuContentsWrapper/PopupMenuContents/PopupMenuItems/PopupHeaderWrapper/PopupHeader/PopupHeaderText
@onready var popup_menu_animation_player = $PopupMenuAnimationPlayer

var popup_action: Callable

var touch_start_time := 0.0
var holding := false
var hold_threshold := 0.3

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false


func _process(_delta):
	pass


func _input(event):
	if !visible:
		return
		
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_time = Time.get_ticks_msec() / 1000.0
			holding = true
		else:
			var duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
			holding = false
			if duration < hold_threshold:
				if !get_global_rect().has_point(event.position):
					hide_menu()


func setup_menu(header: String, content: String, action: Callable):
	popup_header_text.text = header
	popup_content_text.text = content
	popup_action = action
	ok_btn.set_btn_text(header)


func show_menu():
	emit_signal("popup_opened")
	popup_menu_animation_player.play("open")


func hide_menu():
	emit_signal("popup_closed")
	popup_menu_animation_player.play("close")


func _on_ok_btn_pressed():
	if popup_action:
		await RenderingServer.frame_post_draw
		popup_action.call()


func _on_cancel_btn_pressed():
	hide_menu()
