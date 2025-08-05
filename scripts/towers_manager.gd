extends Node2D

# signal upgrade_menu_opened

@onready var game_manager = $"../GameManager"

var tower_menu_opened: bool = false
var last_tower_pressed_id: int
var tower_upgrade_menu: TowerUpgradeMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_upgrade_menu = game_manager.ui.tower_upgrade_menu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		toggle_upgrade_menu(event)


func toggle_upgrade_menu(event):
	if tower_menu_opened:
		if tower_upgrade_menu.get_global_rect().has_point(event.position):
			return
	
	var tower_pressed: bool = false
	for tower in get_children():
		if tower.is_sprite_pressed(event.position):
			if !tower.is_placed:
				return
			
			if !tower_menu_opened:
				tower_pressed = true
				open_tower_menu(tower.tower_stats.tower_upgrades, tower)
			else:
				if last_tower_pressed_id != tower.get_instance_id():
					tower_pressed = true
					open_tower_menu(tower.tower_stats.tower_upgrades, tower)
				else:
					tower_pressed = true
					close_tower_menu()
		
	if tower_menu_opened && !tower_pressed:
		close_tower_menu()

func _on_child_entered_tree(node):
	#node.connect("tower_menu_opened",_on_tower_menu_opened)
	#node.connect("tower_menu_closed",_on_tower_menu_closed)
	node.tower_upgrade_menu = game_manager.ui.tower_upgrade_menu


#func _on_tower_menu_opened(upgrades_data:Resource, caller:Tower):
func open_tower_menu(upgrades_data:Resource, caller:Tower):
	last_tower_pressed_id = caller.get_instance_id()
	tower_menu_opened = true
	game_manager.ui.enable_upgrade_menu(upgrades_data, caller)


#func _on_tower_menu_closed(keep_alive: bool):
func close_tower_menu():
	last_tower_pressed_id = 0
	tower_menu_opened = false
	game_manager.ui.disable_upgrade_menu()
