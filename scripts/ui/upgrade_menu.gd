class_name TowerUpgradeMenu
extends MarginContainer

signal upgrade_purchased(upgrade_cost:int)

@onready var upgrade_banners = $UpgradeMenuItems/OuterContainer/OuterMargin/MenuItems/InnerContainer/InnerContainerMargin/UpgradesSection/UpgradeBannersMargin/UpgradeBanners
@onready var upgrade_menu_items = $UpgradeMenuItems

@onready var resources_panel = $"../../ResourcesPanel"
@onready var tab_buttons_wrapper = $UpgradeMenuItems/TabButtonsWrapper

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


func set_upgrade_menu_alignment(caller: Tower) -> void:
	# set menu's alignment to the opposite side of the tower placement
	if caller.position.x < 0: # tower placed on the left side of the screen
		# set menu to the right
		size_flags_horizontal = Control.SIZE_SHRINK_END
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		upgrade_menu_items.move_child(tab_buttons_wrapper,0)
	else: # tower placed on the right side of the screen
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		upgrade_menu_items.move_child(tab_buttons_wrapper,1)


func open_menu(upgrades_data:Resource, caller: Tower) -> void:
	if !visible:
		set_upgrade_menu_alignment(caller)
	visible = true
	setup_upgrade_banners(upgrades_data, caller)


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
