class_name UIManager
extends Control

var test_tower_1 = preload("res://resources/test_tower.tres")
var test_tower_2 = preload("res://resources/test_tower2.tres")

signal selected_tower(tower: TowerStats)

@onready var button = $VBoxContainer/Button
@onready var button_2 = $VBoxContainer/Button2

func _ready():
	pass

func _process(_delta):
	pass


func _on_button_pressed():
	emit_signal("selected_tower",test_tower_1)

func _on_button_2_pressed():
	emit_signal("selected_tower",test_tower_2)

func _on_button_button_down():
	emit_signal("selected_tower",test_tower_1)

func _on_button_2_button_down():
	emit_signal("selected_tower",test_tower_2)
