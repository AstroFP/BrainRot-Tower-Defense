class_name BuyMenuManager
extends Control

# towers
var test_tower_1 = preload("res://resources/test_tower.tres")
var test_tower_2 = preload("res://resources/test_tower2.tres")

signal selected_tower(tower: TowerStats)

# tower buy buttons
@onready var buy_tower_btn_1 = $TowerBuyMenu/TowerBuyMenuItems/BuyMenuTowerList/BuyMenuTowerListRow1/BuyTowerBtn1
@onready var buy_tower_btn_2 = $TowerBuyMenu/TowerBuyMenuItems/BuyMenuTowerList/BuyMenuTowerListRow1/BuyTowerBtn2

# menu toggle button
@onready var toggle_tower_buy_menu_btn = $ToggleTowerBuyMenuBtn

@onready var tower_buy_menu = $TowerBuyMenu
@onready var playable_area = $"../PlayableArea"

func _ready():
	tower_buy_menu.visible = false

func _process(_delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		var pos = event.position
		if playable_area.get_global_rect().has_point(pos) && !tower_buy_menu.get_global_rect().has_point(pos) && !toggle_tower_buy_menu_btn.get_global_rect().has_point(pos):
			tower_buy_menu.visible = false


func _on_buy_tower_btn_1_button_down():
	emit_signal("selected_tower",test_tower_1)


func _on_buy_tower_btn_1_pressed():
	emit_signal("selected_tower",test_tower_1)


func _on_buy_tower_btn_2_button_down():
	emit_signal("selected_tower",test_tower_2)


func _on_buy_tower_btn_2_pressed():
	emit_signal("selected_tower",test_tower_2)


func _on_toggle_tower_buy_menu_btn_pressed():
	if tower_buy_menu.visible:
		tower_buy_menu.visible = false
	else:
		tower_buy_menu.visible= true
	
