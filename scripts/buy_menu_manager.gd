class_name BuyMenuManager
extends Control

#TODO:
# Scrolling in towers list
# Load towers dynamicly to ui   

# towers
var towers:= [
	preload("res://resources/test_tower.tres"),
	preload("res://resources/test_tower2.tres")
]

signal selected_tower(tower: TowerStats)


# tower buy buttons
@onready var buy_tower_btn_1 = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/BuyMenuTowerList/BuyMenuTowerListRow1/TowerBuyBanner/BuyTowerBtn1
@onready var buy_tower_btn_2 = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/BuyMenuTowerList/BuyMenuTowerListRow1/TowerBuyBanner2/BuyTowerBtn2


# menu toggle button
@onready var toggle_tower_buy_menu_btn = $ToggleTowerBuyMenuBtn

@onready var tower_buy_menu = $TowerBuyMenu
@onready var playable_area = $"../PlayableArea"
@onready var tower_name_label = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/TowerNameLabel
@onready var buy_menu_tower_list = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/BuyMenuTowerList


func _ready():
	tower_buy_menu.visible = false
	set_tower_prices()


func _process(_delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		var pos = event.position
		if playable_area.get_global_rect().has_point(pos) && !tower_buy_menu.get_global_rect().has_point(pos) && !toggle_tower_buy_menu_btn.get_global_rect().has_point(pos):
			tower_buy_menu.visible = false


func _on_buy_tower_btn_1_button_down():
	emit_signal("selected_tower",towers[0])
	update_tower_name_label_text(towers[0])


func _on_buy_tower_btn_1_pressed():
	emit_signal("selected_tower",towers[0])
	update_tower_name_label_text(towers[0])


func _on_buy_tower_btn_2_button_down():
	emit_signal("selected_tower",towers[1])
	update_tower_name_label_text(towers[1])


func _on_buy_tower_btn_2_pressed():
	emit_signal("selected_tower",towers[1])
	update_tower_name_label_text(towers[1])


func _on_toggle_tower_buy_menu_btn_pressed():
	if tower_buy_menu.visible:
		tower_buy_menu.visible = false
	else:
		tower_buy_menu.visible= true


func update_tower_name_label_text(tower_stats:TowerStats):
	tower_name_label.text = tower_stats.name


func set_tower_prices():
	var price_labels = buy_menu_tower_list.find_children("TowerPriceLabel", "Label")
	for i in range(len(price_labels)):
		price_labels[i].text = str(towers[i].price)
