class_name UIManager
extends CanvasLayer

signal money_count_changed(amount:int)

@onready var tower_buy_menu_wrapper = $UIContainer/UI/TowerBuyMenuWrapper
@onready var resources_panel = $UIContainer/UI/ResourcesPanel

var game_rules: GameRules

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup nuy menu
	tower_buy_menu_wrapper.setup_buy_menu(game_rules.available_towers)
	
	# setup resources panel
	resources_panel.setup_resources_panel(game_rules.starting_lives, game_rules.starting_cash)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(_event):
	pass
	
