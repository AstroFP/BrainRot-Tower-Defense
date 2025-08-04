extends Node2D

# signal upgrade_menu_opened

@onready var game_manager = $"../GameManager"

var tower_menu_opened: bool = false
var last_tower_pressed_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_child_entered_tree(node):
	node.connect("tower_menu_opened",_on_tower_menu_opened)
	node.connect("tower_menu_closed",_on_tower_menu_closed)
	node.tower_upgrade_menu = game_manager.ui.tower_upgrade_menu


func _on_tower_menu_opened(upgrades_data:Resource, caller:Tower):
	last_tower_pressed_id = caller.get_instance_id()
	tower_menu_opened = true
	game_manager.ui.enable_upgrade_menu(upgrades_data, caller)


func _on_tower_menu_closed():
	last_tower_pressed_id = 0
	tower_menu_opened = false
	game_manager.ui.disable_upgrade_menu()
