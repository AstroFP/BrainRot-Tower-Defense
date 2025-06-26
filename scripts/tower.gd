class_name Tower
extends Node2D

signal tower_placed(tower:TowerStats)

# TODO:
# *Add functionality to click on the placed towers (for now just to display attack range)

@export var tower_stats: TowerStats

@onready var tower_sprite = $TowerSprite
@onready var attack_range = $AttackRange
@onready var attack_range_hitbox = $AttackRange/AttackRangeHitbox
@onready var attack_range_display = $AttackRange/AttackRangeHitbox/AttackRangeDisplay
@onready var hitbox_collision_box = $Hitbox/HitboxCollisionBox

var is_placed = false
enum placement {valid = 0, invalid = 1}
var placement_state = placement.valid

var colliding_towers:=[]

var scale_factor := 0.15
var min_scale_size := Vector2(128,128)

func _ready():
	# set attack radius
	var attack_radius = CircleShape2D.new()
	attack_radius.radius = tower_stats.attack_radius
	attack_range_hitbox.shape = attack_radius
	
	# set attack radius display
	update_attak_range_display_size()
	update_attack_range_display_color_to_valid()
	
	# set sprite texture
	tower_sprite.texture = tower_stats.texture
	
	# rescale tower
	var texture_size = tower_sprite.texture.get_size()
	var desired_size = texture_size * scale_factor
	if desired_size.x < min_scale_size.x || desired_size.y < min_scale_size.y:
		var min_scale_x = min_scale_size.x / texture_size.x
		var min_scale_y = min_scale_size.y / texture_size.y
		tower_sprite.scale = Vector2(min_scale_x, min_scale_y)
	else:
		tower_sprite.scale = Vector2(scale_factor,scale_factor)
	
	# set hitbox size
	var hitbox_radius = CapsuleShape2D.new()
	hitbox_radius.radius = texture_size.x * tower_sprite.get_scale().x
	hitbox_radius.height = texture_size.y * tower_sprite.get_scale().y
	hitbox_collision_box.shape = hitbox_radius
	
	# disable AI
	set_process(false)
	set_physics_process(false)
	#process_mode = Node.PROCESS_MODE_DISABLED


func _physics_process(_delta):
	pass


func place_tower():
	is_placed = true
	set_process(true)
	set_physics_process(true)
	toggle_attack_range_display()
	
	#Add a CombatManager scene from resources
	#We take the scene out of a dictionary stored in tower_stats.gd
	#We refer to the entry of that dictionary by using an combat_manager_type variable (also from tower_stats.gd)
	var combat_manager_scene_path =  tower_stats.COMBAT_MANAGER_SCENES[tower_stats.combat_manager_type]
	var combat_manager_scene = load(combat_manager_scene_path)
	add_child(combat_manager_scene.instantiate())
	
	emit_signal("tower_placed",tower_stats)


func update_attak_range_display_size():
	var texture_size = attack_range_display.get_texture().get_size()
	var attack_range_scale_factor = (tower_stats.attack_radius * 2.0) / texture_size.x
	attack_range_display.scale = Vector2(attack_range_scale_factor, attack_range_scale_factor)


func update_attack_range_display_color_to_valid():
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_valid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_valid)


func update_attack_range_display_color_to_invalid():
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_invalid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_invalid)


func toggle_attack_range_display():
	attack_range_display.visible = false if true else true


func _on_hitbox_area_entered(area):
	if area.is_in_group("TowerCollidable") && !is_placed:
		colliding_towers.append(area)
		placement_state = placement.invalid
		update_attack_range_display_color_to_invalid()


func _on_hitbox_area_exited(area):
	if area.is_in_group("TowerCollidable") && !is_placed:
		colliding_towers.pop_at(colliding_towers.find(area))
		if colliding_towers.is_empty():
			placement_state = placement.valid
			update_attack_range_display_color_to_valid()
