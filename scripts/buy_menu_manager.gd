class_name BuyMenuManager
extends Control

signal selected_tower_pressed(tower: TowerStats)
signal selected_tower_down(tower: TowerStats)

# towers
var towers: Array[TowerStats]
var tower_banners: Array[TowerBuyBanner]

var tower_buy_banner = preload("res://scenes/ui/tower_buy_banner.tscn")


# menu toggle button
@onready var toggle_tower_buy_menu_btn = $RightMenuBtnContainer/ToggleTowerBuyMenuBtn

@onready var tower_buy_menu = $TowerBuyMenu
@onready var playable_area = $"../PlayableArea"
@onready var buy_menu_tower_list = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/BuyMenuTowerScroll/BuyMenuTowerList
@onready var pause_btn = $RightMenuBtnContainer/PauseBtn
@onready var play_btn = $RightMenuBtnContainer/PlayBtn
@onready var tower_name_label = $TowerBuyMenu/TowerBuyMenyItemsWrapper/TowerBuyMenuItems/TowerNameLabelWrapper/TowerNameLabel
@onready var animation_player = $AnimationPlayer

var current_tower_name := ""

func _ready():
	# setup process mode
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	tower_buy_menu.visible = false
	tower_name_label.text = current_tower_name
	
	
func _process(_delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		var pos = event.position
		
		#if !playable_area.get_global_rect().has_point(pos):
			#return
			#
		#if tower_buy_menu.get_global_rect().has_point(pos):
			#return
		#
		#if toggle_tower_buy_menu_btn.get_global_rect().has_point(pos):
			#return
		#
		#if pause_btn.get_global_rect().has_point(pos):
			#return
		#
		#if  play_btn.get_global_rect().has_point(pos):
			#return
			
		#tower_buy_menu.visible = false
		
		#if playable_area.get_global_rect().has_point(pos) && !tower_buy_menu.get_global_rect().has_point(pos) && !toggle_tower_buy_menu_btn.get_global_rect().has_point(pos) && !pause_btn.get_global_rect().has_point(pos) && !play_btn.get_global_rect().has_point(pos):
			#tower_buy_menu.visible = false


func _on_buy_tower_button_pressed(tower:TowerStats, banner: TowerBuyBanner):
	emit_signal("selected_tower_pressed", tower, banner)
	
	if banner.is_selected:
		update_tower_name_label_text(tower)
	else:
		reset_tower_name_label_text()


func _on_buy_tower_button_down(tower: TowerStats, banner: TowerBuyBanner):
	emit_signal("selected_tower_down",tower, banner)


func _on_toggle_tower_buy_menu_btn_pressed():
	if tower_buy_menu.visible:
		animation_player.play("close")
		#tower_buy_menu.visible = false
	else:
		#tower_buy_menu.visible= true
		animation_player.play("open")



func _on_banner_pressed(banner: TowerBuyBanner):
	update_tower_name_label_text(banner.tower)


func update_tower_name_label_text(tower_stats:TowerStats):
	current_tower_name = tower_stats.name
	tower_name_label.text = tower_stats.name


func reset_tower_name_label_text():
	tower_name_label.text = ""
	current_tower_name = ""


func load_tower_name_label_text():
	tower_name_label.text = current_tower_name


func setup_buy_menu(towers_stats_list:Array[TowerStats]):
	towers = towers_stats_list
	setup_buy_menu_towers()

# buyTowerBtn should be a class with a tower connected to it
func setup_buy_menu_towers():
	var buy_menu_tower_list_row = create_buy_menu_tower_list_row()
	
	for i in range(len(towers)):
		var loaded_tower_buy_banner = tower_buy_banner.instantiate() as TowerBuyBanner
		loaded_tower_buy_banner.tower = towers[i].duplicate()
		loaded_tower_buy_banner.connect("buy_button_pressed", _on_buy_tower_button_pressed.bind(loaded_tower_buy_banner))
		loaded_tower_buy_banner.connect("buy_button_down", _on_buy_tower_button_down.bind(loaded_tower_buy_banner))
		loaded_tower_buy_banner.connect("banner_selected",  _on_banner_pressed.bind(loaded_tower_buy_banner))
		
		# create new list row after inserting 2 banners to the previou one
		if i % 2 == 0 && i != 0:
			buy_menu_tower_list_row = create_buy_menu_tower_list_row()
		
		buy_menu_tower_list_row.add_child(loaded_tower_buy_banner)
		tower_banners.append(loaded_tower_buy_banner)
	
	buy_menu_tower_list.setup_banner_tracking()

func create_buy_menu_tower_list_row():
	var buy_menu_tower_list_row = HBoxContainer.new()
	buy_menu_tower_list_row.add_theme_constant_override("separation",6)
	buy_menu_tower_list_row.name = "BuyMenuTowerListRow"
	buy_menu_tower_list.add_child(buy_menu_tower_list_row)
	return buy_menu_tower_list_row


func _on_available_money_changed(available_money: int):
	for tower_banner in tower_banners:
		tower_banner.update_banner_display(available_money)
