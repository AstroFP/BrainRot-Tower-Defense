extends VBoxContainer

@onready var upgrades_tab_btn = $TabButtonsWrapper/Buttons/UpgradesTabBtn
@onready var stats_tab_btn = $TabButtonsWrapper/Buttons/StatsTabBtn

@onready var upgrades_section = $OuterContainer/OuterMargin/MenuItems/InnerContainer/InnerContainerMargin/UpgradesSection
@onready var stats_section = $OuterContainer/OuterMargin/MenuItems/InnerContainer/InnerContainerMargin/StatsSection


func _ready():
	upgrades_section.visible = true
	stats_section.visible = false


func _process(delta):
	pass


func _on_upgrades_tab_btn_pressed():
	upgrades_section.visible = true
	stats_section.visible = false


func _on_stats_tab_btn_pressed():
	upgrades_section.visible = false
	stats_section.visible = true
