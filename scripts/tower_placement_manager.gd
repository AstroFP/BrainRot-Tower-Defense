class_name TowerPlacementManager
extends Node2D

@onready var camera_2d = $"../Camera2D"
@onready var v_box_container = $"../UICanvas/UI/VBoxContainer"

var tower : PackedScene = preload("res://scenes/tower.tscn")
var tower_stats: TowerStats = preload("res://resources/test_tower.tres")

var is_touching_buy_menu := false
var is_dragging := false
var dragging_velocity := Vector2.ZERO

var tower_selected = ""
var spawned_tower: Tower
var touch_position: Vector2

var max_slow_distance := 400.0
var min_dragging_speed_scale:= 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawned_tower:
		var dragging_speed_scale:float
		var node_rect = Rect2(spawned_tower.global_position - spawned_tower.tower_sprite.texture.get_size()*0.5*spawned_tower.scale,
			spawned_tower.tower_sprite.texture.get_size() * spawned_tower.scale)
			
		var distance = spawned_tower.global_position.distance_to(touch_position)
		if node_rect.has_point(touch_position):
			dragging_speed_scale = 1.0
		else:
			dragging_speed_scale = clamp(1.0 - (distance / max_slow_distance),min_dragging_speed_scale,1.0)
		
		spawned_tower.global_position += dragging_velocity * dragging_speed_scale
		dragging_velocity = Vector2.ZERO
		
		if !is_dragging:
			if spawned_tower.placement_state == 0:
				spawned_tower.place_tower()
				tower_selected = ""
				spawned_tower = null
		
func _input(event):
	if event is InputEventScreenTouch || event is InputEventScreenDrag:
		var pos = event.position
		if v_box_container.get_global_rect().has_point(pos):
			if spawned_tower:
				spawned_tower.queue_free()
				tower_selected = ""
	
	if event is InputEventScreenTouch:
		is_dragging = event.is_pressed()
		dragging_velocity = Vector2.ZERO
	elif event is InputEventScreenDrag && is_dragging:
		dragging_velocity = event.relative
		
	if is_dragging:
		touch_position = event.position * get_canvas_transform() # this took me like an hour to figure out 🙃
		
		
func _on_v_box_container_mouse_entered():
	is_touching_buy_menu = true
	print("mouse_entered")



func _on_v_box_container_mouse_exited():
	is_touching_buy_menu = false
	print("mouse_exited")
	if tower_selected == "test_tower" && is_dragging:
		print("Tower spawned!")
		spawned_tower = tower.instantiate()
		spawned_tower.tower_stats = tower_stats
		get_tree().root.add_child(spawned_tower)
		spawned_tower.global_position = get_global_mouse_position()

func _on_button_pressed():
	tower_selected = "test_tower"
	

func _on_button_button_down():
	tower_selected = "test_tower"
	print("btn down")
