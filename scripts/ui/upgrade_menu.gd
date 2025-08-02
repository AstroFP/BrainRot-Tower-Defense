class_name TowerUpgradeMenu
extends MarginContainer

@onready var upgrade_banners = $UpgradeMenuItems/OuterContainer/OuterMargin/MenuItems/InnerContainer/InnerContainerMargin/UpgradesSection/UpgradeBannersMargin/UpgradeBanners

var banner_colors: Array[Dictionary] = [
	{ "top": Color("75D795"), "bottom": Color("288A49") },
	{ "top": Color("75A6D7"), "bottom": Color("28598A") },
	{ "top": Color("9E75D7"), "bottom": Color("51288A") },
	{ "top": Color("D7BE75"), "bottom": Color("8A7228") },
	{ "top": Color("D77575"), "bottom": Color("8A2828") },
]

var banners: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	banners = upgrade_banners.get_children()
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open_menu(path_data:Dictionary, upgrades_data:Resource) -> void:
	setup_upgrade_banners(path_data,upgrades_data)
	visible = true


func close_menu() -> void:
	visible = false


func setup_upgrade_banners(paths_data: Dictionary, upgrade_data:Resource) -> void:
	var idx = 1
	for banner: UpgradeBanner in banners:
		var path_idx = "path_"+str(idx)
		banner.change_inner_bg_color(banner_colors[paths_data[path_idx]])
		banner.set_price(upgrade_data.upgrades[path_idx]["upgrades"][paths_data[path_idx]].cost)
		banner.set_upgrade_name(upgrade_data.upgrades[path_idx]["upgrades"][paths_data[path_idx]].name)
		idx += 1
