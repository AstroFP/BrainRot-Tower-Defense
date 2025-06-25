class_name ResourcesPanel
extends MarginContainer

signal available_money_changed(available_money: int)

@onready var money_icon = $ResourcesPanelItems/MoneyDisplayPanel/MoneyDisplayPanelItems/MoneyIcon
@onready var health_icon = $ResourcesPanelItems/HealthDisplayPanel/HealthDisplayPanelItems/HealthIcon

@onready var health_count = $ResourcesPanelItems/HealthDisplayPanel/HealthDisplayPanelItems/HealthCount
@onready var money_count = $ResourcesPanelItems/MoneyDisplayPanel/MoneyDisplayPanelItems/MoneyCount

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func setup_resources_panel(starting_health_count: int, starting_cash_count: int):
	health_count.text = str(starting_health_count)
	money_count.text = str(starting_cash_count)
	emit_signal("available_money_changed", starting_cash_count)


func update_health_count(amount: int):
	health_count.text = str(amount)


func update_money_count(amount: int):
	money_count.text = str(amount)
	emit_signal("available_money_changed", amount)


func update_health_icon(texture: Texture2D):
	health_icon.texture = texture


func update_money_icon(texture: Texture2D):
	money_icon.texture = texture
