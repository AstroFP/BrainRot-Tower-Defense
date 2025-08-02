extends Node2D

signal upgrade_menu_opened

@onready var game_manager = $"../GameManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_child_entered_tree(node):
	node.connect("tower_menu_opened",_on_tower_menu_opened)
	node.connect("tower_menu_closed",_on_tower_menu_closed)
	node.tower_upgrade_menu = game_manager.ui.tower_upgrade_menu


func _on_tower_menu_opened(path_data:Dictionary, upgrades_data:Resource):
	game_manager.ui.enable_upgrade_menu(path_data,upgrades_data)


func _on_tower_menu_closed():
	game_manager.ui.disable_upgrade_menu()
