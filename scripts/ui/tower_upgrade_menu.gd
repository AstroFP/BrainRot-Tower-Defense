class_name TowerUpgradeMenuDEP
extends MarginContainer

@onready var upgrade_banner_path_1 = $TowerUpgradeMenu/TowerUpgradeMenuItemsWrapper/TowerUpgradeMenuItmesInnerBg/TowerUpgradeMenuItems/TowerUpgradeTabContainer/Upgrades/UpgradeBannersContainer/UpgradeBannerPath1
@onready var upgrade_banner_path_2 = $TowerUpgradeMenu/TowerUpgradeMenuItemsWrapper/TowerUpgradeMenuItmesInnerBg/TowerUpgradeMenuItems/TowerUpgradeTabContainer/Upgrades/UpgradeBannersContainer/UpgradeBannerPath2
@onready var upgrade_banner_path_3 = $TowerUpgradeMenu/TowerUpgradeMenuItemsWrapper/TowerUpgradeMenuItmesInnerBg/TowerUpgradeMenuItems/TowerUpgradeTabContainer/Upgrades/UpgradeBannersContainer/UpgradeBannerPath3
@onready var upgrade_banners_container = $TowerUpgradeMenu/TowerUpgradeMenuItemsWrapper/TowerUpgradeMenuItmesInnerBg/TowerUpgradeMenuItems/TowerUpgradeTabContainer/Upgrades/UpgradeBannersContainer


var banner_colors: Array[Dictionary] = [
	{ "top": Color("75D795"), "bottom": Color("288A49") },
	{ "top": Color("75A6D7"), "bottom": Color("28598A") },
	{ "top": Color("9E75D7"), "bottom": Color("51288A") },
	{ "top": Color("D7BE75"), "bottom": Color("8A7228") },
	{ "top": Color("D77575"), "bottom": Color("8A2828") },
]

# Called when the node enters the scene tree for the first time.
func _ready():
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
	for banner in upgrade_banners_container.get_children():
		var path_idx = "path_"+str(idx)
		banner.get_node("UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBanner").material.set_shader_parameter("color_top",banner_colors[paths_data[path_idx]]["top"])
		banner.get_node("UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBanner").material.set_shader_parameter("color_bottom",banner_colors[paths_data[path_idx]]["bottom"])
	
		banner.get_node("UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBanner/UpgradeBannerItemsWrapper/UpgradeBannerItems/UpgradeName").text = upgrade_data.upgrades[path_idx]["upgrades"][paths_data[path_idx]].name
		banner.get_node("UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBanner/UpgradeBannerItemsWrapper/UpgradeBannerItems/PriceTag/Price").text = str(upgrade_data.upgrades[path_idx]["upgrades"][paths_data[path_idx]].cost)
		
		idx += 1
