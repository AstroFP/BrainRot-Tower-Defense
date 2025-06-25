class_name ResourcesPanel
extends MarginContainer

@onready var money_icon = $ResourcesPanelItems/MoneyDisplayPanel/MoneyDisplayPanelItems/MoneyIcon
@onready var health_icon = $ResourcesPanelItems/HealthDisplayPanel/HealthDisplayPanelItems/HealthIcon

@onready var health_count = $ResourcesPanelItems/HealthDisplayPanel/HealthDisplayPanelItems/HealthCount
@onready var money_count = $ResourcesPanelItems/MoneyDisplayPanel/MoneyDisplayPanelItems/MoneyCount

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setup_resources_panel(starting_health_count: int, starting_cash_count: int):
	health_count.text = str(starting_health_count)
	money_count.text = str(starting_cash_count)


func update_health_count(amount: int):
	health_count.text = str(int(health_count.text) + amount)


func update_money_count(amount: int):
	money_count.text = str(int(money_count.text) + amount)


func update_health_icon(texture: Texture2D):
	health_icon.texture = texture


func update_money_icon(texture: Texture2D):
	money_icon.texture = texture
