class_name UIManager
extends CanvasLayer

#signal money_count_changed(amount:int)
signal play_btn_pressed

@onready var tower_buy_menu_wrapper = $UIContainer/UI/TowerBuyMenuWrapper
@onready var resources_panel = $UIContainer/UI/ResourcesPanel
@onready var game_over_panel = $UIContainer/UI/GameOverPanel
@onready var play_btn = $UIContainer/UI/TowerBuyMenuWrapper/RightMenuBtnContainer/PlayBtn
@onready var pause_menu = $UIContainer/UI/PauseMenu

var game_rules: GameRules

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup process mode
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# setup nuy menu
	tower_buy_menu_wrapper.setup_buy_menu(game_rules.available_towers)
	
	# setup resources panel
	resources_panel.setup_resources_panel(game_rules.starting_lives, game_rules.starting_cash)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_money_count(amount: int):
	resources_panel.update_money_count(amount)

func update_health_count(amount: int):
	resources_panel.update_health_count(amount)

func show_game_over_panel(waves_survived: int):
	game_over_panel.show_game_over_panel(waves_survived)


# signal handlers
func _on_play_btn_pressed():
	emit_signal("play_btn_pressed")
