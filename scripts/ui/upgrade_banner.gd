class_name  UpgradeBanner
extends PanelContainer

signal upgrade_purchased(caller:Tower,upgrade_price:int)

const PATH_MAXED_ICON = preload("res://assets/sprites/ui/upgrade_menu/path_maxed_icon.png")
const PATH_BLOCKED_ICON = preload("res://assets/sprites/ui/upgrade_menu/path_blocked_icon.png")

@onready var upgrade_menu = $"../../../../../../../../../.."

@onready var upgrade_name = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/UpgradeName
@onready var upgrade_icon = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/UpgradeIcon
@onready var price = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/PriceTag/Price
@onready var upgrade_banner_inner = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner
@onready var buy_btn = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/BuyBtn
@onready var price_tag = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/PriceTag

var tower_upgrade_data: BasicUpgrade
var upgrade_path_name: String
#var path_maxed: bool = false
#var path_blocked: bool = false
var is_disabled: bool = false
var current_tier_color: Dictionary

var current_caller: Tower
var current_path_name: String
var current_upgrades: Array
var current_upgrade_index: int

var banner_stats = UpgradeBannerStats.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	current_tier_color = banner_stats.green_colors


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_upgrade_banner_display(available_money: int):
	if current_caller.upgrades_manager.upgrades_amount_per_path[current_path_name] == 5:
		return
		
	if current_caller.upgrades_manager.upgrades_count == 7:
		return
		
	if is_disabled:
		if available_money >= int(price.text):
			enable_tower_panel()
	else:
		if available_money < int(price.text):
			disable_tower_panel()


func disable_tower_panel():
	# set font color to red
	price.add_theme_color_override("font_color",Color.DARK_RED)
	upgrade_name.add_theme_color_override("font_color",Color.DARK_RED)
	# set colors to grayscale
	var color = banner_stats.gray_colors

	upgrade_banner_inner.material.set_shader_parameter("color_top", color["top"])
	upgrade_banner_inner.material.set_shader_parameter("color_bottom", color["bottom"])
	
	is_disabled = true


func enable_tower_panel():
	# reset font color 
	price.remove_theme_color_override("font_color")
	upgrade_name.remove_theme_color_override("font_color")
	# enable colors
	upgrade_banner_inner.material.set_shader_parameter("color_top", current_tier_color["top"])
	upgrade_banner_inner.material.set_shader_parameter("color_bottom", current_tier_color["bottom"])
	
	is_disabled = false


func set_price(value: int) -> void:
	price.text = str(value)


func disable_price_tag() -> void:
	price_tag.visible = false


func set_upgrade_icon(texture: Texture2D) -> void:
	upgrade_icon.texture = texture


func set_upgrade_name(value: String) -> void:
	upgrade_name.text = value


func change_inner_bg_color(index: int) -> void:
	index = clamp(index,0,4)
	var colors: Dictionary = banner_stats.banner_colors_list[index]
	current_tier_color = colors
	if !is_disabled:
		upgrade_banner_inner.material.set_shader_parameter("color_top", colors["top"])
		upgrade_banner_inner.material.set_shader_parameter("color_bottom", colors["bottom"])


func setup_banner(upgrades:Array, caller:Tower, path_name: String) -> void:
	# setup crucial upgrade variables
	current_upgrades = upgrades
	current_caller = caller
	current_path_name = path_name
	
	current_upgrade_index = current_caller.upgrades_manager.upgrades_amount_per_path[current_path_name]
	current_upgrade_index = clamp(current_upgrade_index,0,4)
	var current_upgrade = current_upgrades[current_upgrade_index]
	
	# setup banner data
	change_inner_bg_color(current_upgrade_index)
	set_price(current_upgrade.cost)
	if current_caller.upgrades_manager.upgrades_amount_per_path[current_path_name] == 5:
		set_upgrade_name("Max upgrades")
		set_maxed_icon()
	elif current_caller.upgrades_manager.upgrades_count == 7:
		set_upgrade_name("Max upgrades")
		set_blocked_icon()
	else:
		set_upgrade_icon(current_upgrade.icon)
		set_upgrade_name(current_upgrade.name)
	
	enable_tower_panel()
	update_upgrade_banner_display(int(upgrade_menu.resources_panel.money_count.text))


func load_next_upgrade() -> void:
	if current_upgrade_index == 5:
		is_disabled = true
		set_maxed_icon()
		disable_price_tag()
		set_upgrade_name("Max upgrades")
	elif current_caller.upgrades_manager.upgrades_count == 7:
		is_disabled = true
		set_blocked_icon()
		disable_price_tag()
		set_upgrade_name("Max upgrades")
	else:
		var current_upgrade = current_upgrades[current_upgrade_index]
		
		# setup banner data
		change_inner_bg_color(current_upgrade_index)
		set_price(current_upgrade.cost)
		set_upgrade_name(current_upgrade.name)
		set_upgrade_icon(current_upgrade.icon)
		# idonno if its needed here gotta test it
		update_upgrade_banner_display(int(upgrade_menu.resources_panel.money_count.text))


func set_maxed_icon() -> void:
	set_upgrade_icon(PATH_MAXED_ICON)


func set_blocked_icon() -> void:
	set_upgrade_icon(PATH_BLOCKED_ICON)


func _on_buy_btn_pressed():
	if is_disabled:
		return
	
	# apply upgrade to the caller tower
	current_caller.upgrades_manager.aplly_upgrade(current_upgrades[current_upgrade_index])
	
	# update caller towers upgrades count in the current path
	current_caller.upgrades_manager.increment_path_upgrade_count(current_path_name)
	current_upgrade_index = current_caller.upgrades_manager.upgrades_amount_per_path[current_path_name]
	# load next upgrade from the upgrades list
	load_next_upgrade()
	
	# send purchased signal (index - 1, because we incremented it earlier)
	emit_signal("upgrade_purchased",current_caller, current_upgrades[current_upgrade_index - 1].cost)
