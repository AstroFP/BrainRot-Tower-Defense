class_name TowerStats
extends Resource

@export var name: String
@export var texture: Texture2D
@export var icon: Texture2D
@export var price:= 0
@export var damage:= 1
@export var pierce:= 1
@export_range(0, 800, 0.1, "or_greater") var attack_radius:= 500.0

var attack_range_display_color_valid := Color(.5, .5, .5, .5)
var attack_range_display_border_color_valid := Color(.3, .3, .3, .5)
var attack_range_display_color_invalid:= Color(1, .3, .1, .5)
var attack_range_display_border_color_invalid:= Color(1, 0, 0, .5)
