class_name TowerUpgradeMenu
extends MarginContainer

@onready var upgrade_banners = $UpgradeMenuItems/OuterContainer/OuterMargin/MenuItems/InnerContainer/InnerContainerMargin/UpgradesSection/UpgradeBannersMargin/UpgradeBanners

@onready var resources_panel = $"../ResourcesPanel"

var banners: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	banners = upgrade_banners.get_children()
	visible = false
	
	# connect purchased signal
	for banner: UpgradeBanner in banners:
		banner.connect("upgrade_purchased", _on_upgrade_purchased)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open_menu(path_data:Dictionary, upgrades_data:Resource, caller: Tower) -> void:
	setup_upgrade_banners(path_data, upgrades_data, caller)
	visible = true


func close_menu() -> void:
	visible = false

# refactor the code cuz its disgusting
# add max upgrades icon and max level (7 upgrades overall) and handling
# check if colors are the same as design in figma
# add some testing upgrades
# implement affordable and not affordable functionality
# implement payment for upgrades

func setup_upgrade_banners(paths_data: Dictionary, upgrade_data:Resource, caller: Tower) -> void:
	var idx = 1
	for banner: UpgradeBanner in banners:
		var path_name = "path_"+str(idx)
		var upgrades = upgrade_data.upgrades[path_name]["upgrades"]
		banner.setup_banner(upgrades, caller, path_name)
		idx += 1


func _on_available_money_changed(available_money: int) -> void:
	for banner:UpgradeBanner in banners:
		if banner.current_caller:
			banner.update_upgrade_banner_display(available_money)


func _on_upgrade_purchased(caller:Tower):
	if caller.upgrades_manager.upgrades_count >= 7:
		for banner:UpgradeBanner in banners:
			if !caller.upgrades_manager.upgrades_amount_per_path[banner.current_path_name] == 5:
				banner.set_blocked_icon()
				banner.disable_price_tag()
			banner.is_disabled = true
