class_name TowerPlacementManager
extends Node2D

signal selected_tower_placed(tower)

# parameters and flags for screen input
var is_touching_inside_play_area := false
var is_touching_buy_menu := false
var is_touching_toggle_buy_menu_btn := false
var is_dragging := false
var dragging_speed_capped := false
var dragging_velocity := Vector2.ZERO
var max_slow_distance := 400.0
var min_dragging_speed_scale:= 0.2
var touch_position: Vector2

# parameters and flag for tower spawning
var tower : PackedScene = preload("res://scenes/tower.tscn")
var tower_selected: TowerStats = null
var spawned_tower: Tower
var is_tower_ready_to_spawn = false

var screen_rect : Rect2

var ui: UIManager
var tower_buy_menu: MarginContainer
var playable_area: MarginContainer
var toggle_buy_menu_btn: Button

func _ready():
	# setup process mode
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# link ui elements
	tower_buy_menu = ui.find_child("TowerBuyMenu")
	playable_area = ui.find_child("PlayableArea")
	toggle_buy_menu_btn = ui.find_child("ToggleTowerBuyMenuBtn")
	
	# connect selected tower signal
	ui.find_child("TowerBuyMenuWrapper").connect("selected_tower",_on_selected_tower)

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
		var spawned_tower_rect = Rect2(
			spawned_tower.global_position - tower_half_size,
			spawned_tower.tower_sprite.texture.get_size()*spawned_tower.tower_sprite.get_scale()
			)
			
		if spawned_tower_rect.has_point(touch_position) && !dragging_speed_capped:
			dragging_speed_capped = true
			
		if dragging_speed_capped:
			dragging_speed_scale = 1.0
		else:
			var tower_closest_ponit_to_touch = touch_position.clamp(spawned_tower_rect.position, spawned_tower_rect.position+spawned_tower_rect.size)
			var distance_to_closest_point = touch_position.distance_to(tower_closest_ponit_to_touch)
			dragging_speed_scale = clamp(1.0 - (distance_to_closest_point / max_slow_distance),min_dragging_speed_scale,1.0)
		
		spawned_tower.global_position += dragging_velocity * dragging_speed_scale
		
		# clamp tower so it cannot go outside the screen
		spawned_tower.global_position.x = clamp(spawned_tower.global_position.x, screen_rect.position.x + tower_half_size.x * 0.2, screen_rect.end.x - tower_half_size.x* 0.2)
		spawned_tower.global_position.y = clamp(spawned_tower.global_position.y, screen_rect.position.y + tower_half_size.y * 0.2, screen_rect.end.y - tower_half_size.y* 0.2)
		
		dragging_velocity = Vector2.ZERO
		
		if !is_dragging:
			dragging_speed_capped = false
			if spawned_tower.placement_state == 0:
				spawned_tower.place_tower()
				tower_selected = null
				spawned_tower = null
				tower_buy_menu.visible = true


func _input(event):
	if event is InputEventScreenDrag || event is InputEventScreenTouch:
		var pos = event.position
		is_touching_inside_play_area = playable_area.get_global_rect().has_point(pos)
		is_touching_buy_menu = tower_buy_menu.get_global_rect().has_point(pos)
		is_touching_toggle_buy_menu_btn = toggle_buy_menu_btn.get_global_rect().has_point(pos)
	
	if  (is_touching_buy_menu || !is_touching_inside_play_area) && spawned_tower:
		spawned_tower.queue_free()
		tower_selected = null
		tower_buy_menu.visible = true
	
	if is_tower_ready_to_spawn && !is_touching_buy_menu:
		tower_buy_menu.visible = false
		spawn_tower()
		
	if is_tower_ready_to_spawn && !is_touching_inside_play_area:
		tower_selected = null
		is_tower_ready_to_spawn = false
		tower_buy_menu.visible = true
		
	if is_tower_ready_to_spawn && is_touching_toggle_buy_menu_btn:
		tower_selected = null
		is_tower_ready_to_spawn = false
		tower_buy_menu.visible = true
		
	if event is InputEventScreenTouch:
		is_dragging = event.is_pressed()
		dragging_velocity = Vector2.ZERO
	elif event is InputEventScreenDrag && is_dragging:
		dragging_velocity = event.relative
	
	if is_dragging && event is InputEventScreenTouch || event is InputEventScreenDrag:
		touch_position = event.position * get_canvas_transform() # this took me like an hour to figure out 🙃


func spawn_tower():
	if tower_selected && is_dragging:
		spawned_tower = tower.instantiate()
		spawned_tower.tower_stats = tower_selected.duplicate()
		spawned_tower.connect("tower_placed",_on_tower_placed)
		get_parent().get_parent().add_child(spawned_tower)
		spawned_tower.global_position = touch_position
		is_tower_ready_to_spawn = false


func _on_selected_tower(tower_stats):
	tower_selected = tower_stats
	is_tower_ready_to_spawn = true


func _on_tower_placed(tower_stats):
	emit_signal("selected_tower_placed",tower_stats)
