class_name UIManager
extends CanvasLayer

#signal money_count_changed(amount:int)
signal play_btn_pressed
signal pause_game
signal unpause_game

@onready var tower_buy_menu_wrapper = $UIContainer/UI/TowerBuyMenuWrapper
@onready var resources_panel = $UIContainer/UI/ResourcesPanel
@onready var play_btn = $UIContainer/UI/TowerBuyMenuWrapper/RightMenuBtnContainer/PlayBtn
@onready var pause_menu_wrapper = $UIContainer/UI/PauseMenuWrapper
@onready var pause_btn = $UIContainer/UI/TowerBuyMenuWrapper/RightMenuBtnContainer/PauseBtn
@onready var paused_background_overlay = $PausedBackgroundOverlay
@onready var wave_display = $UIContainer/UI/WaveDisplay
@onready var buy_menu_tower_list = $UIContainer/UI/TowerBuyMenuWrapper/TowerBuyMenu/TowerBuyMenyItemsWrapper/InnerBG/TowerBuyMenuItemsMargins/TowerBuyMenuItems/BuyMenuTowerScroll/BuyMenuTowerList
@onready var popup_menu = $UIContainer/UI/PopupMenu
@onready var popup_menu_background_overlay = $PopupMenuBackgroundOverlay
@onready var game_over_panel: GameOverPanel = $UIContainer/UI/GameOverPanelWrapper
@onready var tower_upgrade_menu = $UIContainer/UI/UpgradeMenu




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


func update_wave_display(wave_number: int):
	wave_display.update_wave_display(wave_number)


func reset_buy_menu_tower_label():
	tower_buy_menu_wrapper.reset_tower_name_label_text()


func reset_buy_menu_selection_outline():
	buy_menu_tower_list.reset_selection()


# signal handlers
func _on_play_btn_pressed():
	emit_signal("play_btn_pressed")


func _on_pause_btn_pressed():
	pause_menu_wrapper.show_pause_menu()


func _on_pause_menu_opened():
	enable_paused_background_overlay()
	emit_signal("pause_game")


func _on_pause_menu_closed():
	emit_signal("unpause_game")
	await  get_tree().create_timer(0.5).timeout
	disable_paused_background_overlay()


func disable_paused_background_overlay():
	paused_background_overlay.visible = false

func enable_paused_background_overlay():	
	paused_background_overlay.visible = true


func disable_popup_background_overlay():
	popup_menu_background_overlay.visible = false


func enable_popup_background_overlay():
	popup_menu_background_overlay.visible = true


func _on_popup_menu_popup_opened():
	pause_menu_wrapper.disable_input()
	enable_popup_background_overlay()


func _on_popup_menu_popup_closed():
	await get_tree().create_timer(0.4).timeout
	pause_menu_wrapper.enable_input()
	disable_popup_background_overlay()


func enable_upgrade_menu(path_data:Dictionary, upgrades_data:Resource, caller: Tower) -> void:
	tower_upgrade_menu.open_menu(path_data, upgrades_data, caller)


func disable_upgrade_menu() -> void:
	tower_upgrade_menu.close_menu()
