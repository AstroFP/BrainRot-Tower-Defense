class_name UIManager
extends CanvasLayer

#signal money_count_changed(amount:int)
signal play_btn_pressed
signal pause_game
signal unpause_game

@onready var tower_buy_menu_wrapper = $UIContainer/UI/TowerBuyMenuWrapper
@onready var resources_panel = $UIContainer/UI/ResourcesPanel
@onready var game_over_panel = $UIContainer/UI/GameOverPanel
@onready var play_btn = $UIContainer/UI/TowerBuyMenuWrapper/RightMenuBtnContainer/PlayBtn
@onready var pause_menu_wrapper = $UIContainer/UI/PauseMenuWrapper
@onready var pause_btn = $UIContainer/UI/TowerBuyMenuWrapper/RightMenuBtnContainer/PauseBtn
@onready var paused_background_overlay = $PausedBackgroundOverlay

var game_rules: GameRules

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup process mode
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# setup nuy menu
	tower_buy_menu_wrapper.setup_buy_menu(game_rules.available_towers)
	
	# setup resources panel
	resources_panel.setup_resources_panel(game_rules.starting_lives, game_rules.starting_cash)
	
	# hide paused bg overlay
	paused_background_overlay.visible = false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_money_count(amount: int):
	resources_panel.update_money_count(amount)


func update_health_count(amount: int):
	resources_panel.update_health_count(amount)


func show_game_over_panel(waves_survived: int):
	game_over_panel.show_game_over_panel(waves_survived)


func change_play_btn_icon_to_play():
	play_btn.change_icon_to_play()


func change_play_btn_icon_to_fast_forward():
	play_btn.change_icon_to_fast_forwad()


# signal handlers
func _on_play_btn_pressed():
	emit_signal("play_btn_pressed")


func _on_pause_btn_pressed():
	pause_menu_wrapper.show_pause_menu()


func _on_pause_menu_opened():
	toggle_paused_background_overlay()
	emit_signal("pause_game")


func _on_pause_menu_closed():
	toggle_paused_background_overlay()
	emit_signal("unpause_game")


func toggle_paused_background_overlay():
	if paused_background_overlay.visible:
		paused_background_overlay.visible = false
	else:
		paused_background_overlay.visible = true
