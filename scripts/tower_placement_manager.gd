class_name TowerPlacementManager
extends Node2D

@onready var ui_canvas = $"../UICanvas"

# parameters and flags for screen input
var is_touching_inside_play_area := false
var is_touching_buy_menu := false
var is_dragging := false
var dragging_locked := false
var dragging_velocity := Vector2.ZERO
var max_slow_distance := 400.0
var min_dragging_speed_scale:= 0.2
var touch_position: Vector2

# parameters and flag for tower spawning
var tower : PackedScene = preload("res://scenes/tower.tscn")
var tower_selected: TowerStats
var spawned_tower: Tower
var is_tower_ready_to_spawn = false

var tower_buy_menu: MarginContainer
var playable_area: MarginContainer

var screen_rect : Rect2

func _ready():
	tower_buy_menu = ui_canvas.find_child("TowerBuyMenu")
	playable_area = ui_canvas.find_child("PlayableArea")
	ui_canvas.find_child("TowerBuyMenuWrapper").connect("selected_tower",_on_tower_buy_menu_wrapper_selected_tower)

	# calculate side margins for clamping tower placement
	var playable_screen_aspect_ratio := 16.0/9.0
	var viewport_size := get_viewport().get_visible_rect().size
	var viewport_aspect_ratio := viewport_size.x / viewport_size.y

	if viewport_aspect_ratio > playable_screen_aspect_ratio:
		var playable_screen_width = viewport_size.y * playable_screen_aspect_ratio
		var margin_x = (viewport_size.x - playable_screen_width) * 0.5
		screen_rect.position = Vector2(margin_x, 0) * get_canvas_transform()
		screen_rect.size = Vector2(playable_screen_width, viewport_size.y)


func _process(_delta):
	if spawned_tower:
		var dragging_speed_scale:float
		var tower_half_size = spawned_tower.tower_sprite.texture.get_size()*spawned_tower.tower_sprite.get_scale() * 0.5
		var node_rect = Rect2(
			spawned_tower.global_position - tower_half_size,
			spawned_tower.tower_sprite.texture.get_size()*spawned_tower.tower_sprite.get_scale()
			)
			
		if node_rect.has_point(touch_position) && !dragging_locked:
			dragging_locked = true
			
		if dragging_locked:
			dragging_speed_scale = 1.0
		else:
			var closest_ponit = touch_position.clamp(node_rect.position, node_rect.position+node_rect.size)
			var distance = touch_position.distance_to(closest_ponit)
			dragging_speed_scale = clamp(1.0 - (distance / max_slow_distance),min_dragging_speed_scale,1.0)
		
		spawned_tower.global_position += dragging_velocity * dragging_speed_scale
		
		# clamp tower so it cannot go outside the screen
		spawned_tower.global_position.x = clamp(spawned_tower.global_position.x, screen_rect.position.x + tower_half_size.x * 0.2, screen_rect.end.x - tower_half_size.x* 0.2)
		spawned_tower.global_position.y = clamp(spawned_tower.global_position.y, screen_rect.position.y + tower_half_size.y * 0.2, screen_rect.end.y - tower_half_size.y* 0.2)
		
		dragging_velocity = Vector2.ZERO
		
		if !is_dragging:
			dragging_locked = false
			if spawned_tower.placement_state == 0:
				spawned_tower.place_tower()
				tower_selected = null
				spawned_tower = null
				tower_buy_menu.visible = true


func _input(event):
	if event is InputEventScreenTouch || event is InputEventScreenDrag:
		var pos = event.position
		is_touching_inside_play_area = playable_area.get_global_rect().has_point(pos)
		is_touching_buy_menu = tower_buy_menu.get_global_rect().has_point(pos)
	
	if  (is_touching_buy_menu || !is_touching_inside_play_area) && spawned_tower:
		spawned_tower.queue_free()
		tower_selected = null
		tower_buy_menu.visible = true
	
	if is_tower_ready_to_spawn && !is_touching_buy_menu:
		tower_buy_menu.visible = false
		spawn_tower()
	
	if event is InputEventScreenTouch:
		is_dragging = event.is_pressed()
		dragging_velocity = Vector2.ZERO
	elif event is InputEventScreenDrag && is_dragging:
		dragging_velocity = event.relative
	
	if is_dragging:
		touch_position = event.position * get_canvas_transform() # this took me like an hour to figure out 🙃


func spawn_tower():
	if tower_selected && is_dragging:
		spawned_tower = tower.instantiate()
		spawned_tower.tower_stats = tower_selected.duplicate()
		get_tree().root.add_child(spawned_tower)
		spawned_tower.global_position = touch_position
		is_tower_ready_to_spawn = false


func _on_tower_buy_menu_wrapper_selected_tower(tower_stats):
	tower_selected = tower_stats
	is_tower_ready_to_spawn = true
