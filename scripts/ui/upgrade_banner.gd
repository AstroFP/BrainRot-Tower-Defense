class_name  UpgradeBanner
extends PanelContainer

@onready var upgrade_name = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/UpgradeName
@onready var upgrade_icon = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/UpgradeIcon
@onready var price = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner/UpgradeBannerItemsWrapper/UpgradeBannerItems/PriceTag/Price
@onready var upgrade_banner_inner = $UpgradeBannerMargin/UpgradeBannerBorder/UpgradeBannerWrapper/UpgradeBannerInner


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_price(value: int) -> void:
	price.text = str(value)


func set_upgrade_icon(texture: Texture2D) -> void:
	upgrade_icon.texture = texture


func set_upgrade_name(value: String) -> void:
	upgrade_name.text = value


func change_inner_bg_color(colors:Dictionary) -> void:
	upgrade_banner_inner.material.set_shader_parameter("color_top", colors["top"])
	upgrade_banner_inner.material.set_shader_parameter("color_bottom", colors["bottom"])
	
