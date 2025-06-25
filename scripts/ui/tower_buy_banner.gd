class_name TowerBuyBanner
extends PanelContainer

signal buy_button_pressed(tower_stats: TowerStats)

@onready var buy_tower_btn = $BuyTowerBtn
@onready var tower_icon = $TowerBuyBannerItems/TowerIcon
@onready var tower_price_label = $TowerBuyBannerItems/TowerPriceLabel

var tower: TowerStats

var is_disabled = false

func _ready():
	setup_banner()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func setup_banner():
	name = "TowerBuyBanner"
	tower_icon.texture = tower.icon
	tower_price_label.text = str(tower.price)

func disable_tower_panel():
	tower_price_label.add_theme_color_override("font_color",Color.DARK_RED)
	buy_tower_btn.disabled = true
	is_disabled = true

func enable_tower_panel():
	# reset font color 
	tower_price_label.remove_theme_color_override("font_color")
	buy_tower_btn.disabled = false
	is_disabled = false
	
func update_banner_display(available_money):
	if is_disabled:
		if available_money >= int(tower_price_label.text):
			enable_tower_panel()
	else:
		if available_money < int(tower_price_label.text):
			disable_tower_panel()

func _on_buy_tower_btn_pressed():
	emit_signal("buy_button_pressed",tower)


func _on_buy_tower_btn_button_down():
	emit_signal("buy_button_pressed",tower)
