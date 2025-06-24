class_name TowerBuyBanner
extends PanelContainer

signal buy_button_pressed(tower_stats: TowerStats)

@onready var buy_tower_btn = $BuyTowerBtn
@onready var tower_icon = $TowerBuyBannerItems/TowerIcon
@onready var tower_price_label = $TowerBuyBannerItems/TowerPriceLabel

var tower: TowerStats

func _ready():
	setup_banner()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func setup_banner():
	name = "TowerBuyBanner"
	tower_icon.texture = tower.icon
	tower_price_label.text = str(tower.price)


func _on_buy_tower_btn_pressed():
	emit_signal("buy_button_pressed",tower)


func _on_buy_tower_btn_button_down():
	emit_signal("buy_button_pressed",tower)
