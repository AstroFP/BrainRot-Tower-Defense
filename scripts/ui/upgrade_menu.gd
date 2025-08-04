class_name TowerUpgradeMenu
extends MarginContainer

signal upgrade_purchased(upgrade_cost:int)

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
func _process(_delta):
	pass


func open_menu(upgrades_data:Resource, caller: Tower) -> void:
	setup_upgrade_banners(upgrades_data, caller)
	visible = true


func close_menu() -> void:
	visible = false

#TBD overhaul buy menu design and add tower power display (0 - 7 graphical representation of total upgrades acquired)

func setup_upgrade_banners(upgrade_data:Resource, caller: Tower) -> void:
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


func _on_upgrade_purchased(caller:Tower, upgrade_cost: int):
	if caller.upgrades_manager.upgrades_count >= 7:
		for banner:UpgradeBanner in banners:
			if !caller.upgrades_manager.upgrades_amount_per_path[banner.current_path_name] == 5:
				banner.set_blocked_icon()
				banner.disable_price_tag()
				
			# enable the banner for it to have its bg color and font color
			banner.enable_tower_panel()
			# disable it manually to prevent palyer for buying more upgrades
			banner.is_disabled = true
	emit_signal("upgrade_purchased",upgrade_cost)
