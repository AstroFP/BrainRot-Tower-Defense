class_name TowerBuyBanner
extends PanelContainer

signal buy_button_pressed(tower_stats: TowerStats)
signal buy_button_down(tower_stats: TowerStats)
signal buy_button_up
signal banner_pressed
signal banner_selected

@onready var buy_tower_btn = $TowerBuyBannerItemsWrapper/BuyTowerBtn
@onready var tower_price_label = $TowerBuyBannerItemsWrapper/TowerBuyBannerItems/TowerPriceTagWrapper/TowerPriceTag/TowerPriceLabel
@onready var tower_icon = $TowerBuyBannerItemsWrapper/TowerBuyBannerItems/TowerIconWrapper/TowerIcon

var tower: TowerStats
var is_disabled = false
var is_selected = false


func _ready():
	setup_banner()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func setup_banner():
	name = "TowerBuyBanner"
	tower_icon.texture = tower.icon
	tower_price_label.text = str(tower.price)
	
	# set outline to transparent
	hide_outline()
	
	# use it if material resource_local_to_scene = false
	#if buy_tower_btn.material:
		#buy_tower_btn.material = buy_tower_btn.material.duplicate()


func disable_tower_panel():
	# set font color to red
	tower_price_label.add_theme_color_override("font_color",Color.DARK_RED)
	# set colors to grayscale
	buy_tower_btn.material.set_shader_parameter("grayscale_amount", 1.0)
	tower_icon.material.set_shader_parameter("grayscale_amount", 0.5)
	
	is_disabled = true


func enable_tower_panel():
	# reset font color 
	tower_price_label.remove_theme_color_override("font_color")
	# enable colors
	buy_tower_btn.material.set_shader_parameter("grayscale_amount", 0.0)
	tower_icon.material.set_shader_parameter("grayscale_amount", 0.0)
	
	is_disabled = false


func update_banner_display(available_money):
	if is_disabled:
		if available_money >= int(tower_price_label.text):
			enable_tower_panel()
	else:
		if available_money < int(tower_price_label.text):
			disable_tower_panel()


func show_outline():
	var style_box = get("theme_override_styles/panel") as StyleBoxFlat
	if style_box: 
		style_box.bg_color = Color(1, 1, 1, 1)


func hide_outline():
	var style_box = get("theme_override_styles/panel") as StyleBoxFlat
	if style_box: 
		style_box.bg_color = Color(1, 1, 1, 0)


func update_banner_selection_info():
	emit_signal("banner_selected")


func _on_buy_tower_btn_pressed():
	emit_signal("banner_pressed")
	emit_signal("buy_button_pressed",tower)


func _on_buy_tower_btn_button_down():
	emit_signal("buy_button_down",tower)


func _on_buy_tower_btn_button_up():
	emit_signal("buy_button_up")
