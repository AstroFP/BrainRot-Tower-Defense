class_name Tower
extends Node2D

signal tower_placed(tower:TowerStats)

const UPGRADES_MANAGER = preload("res://scenes/upgrades_manager.tscn")

# TODO:
# *Add functionality to click on the placed towers (for now just to display attack range)

@export var tower_stats: TowerStats
#@onready var upgrades_manager: UpgradesManager = $UpgradesManager

@onready var tower_sprite = $TowerSprite
@onready var attack_range = $AttackRange
@onready var attack_range_hitbox = $AttackRange/AttackRangeHitbox
@onready var attack_range_display = $AttackRange/AttackRangeHitbox/AttackRangeDisplay
@onready var hitbox_collision_box = $Hitbox/HitboxCollisionBox

var combat_manager: BasicCombatManager

var is_placed = false
enum placement {valid = 0, invalid = 1}
var placement_state = placement.valid

var colliding_towers:=[]

var scale_factor := 0.15
var min_scale_size := Vector2(128, 128)


# combat variables
var attack_damage: float
var attack_speed: float
var attack_radius: float:
	set(value):
		if attack_radius != value:
			attack_radius = value
			update_attack_range_hitbox_size()
			update_attack_range_display_size()
	get:
		return attack_radius
var pierce: int
var attack_damage_multiplier: float
var attack_speed_multiplier: float
var attack_radius_multiplier: float:
	set(value):
		if attack_radius_multiplier != value:
			attack_radius_multiplier = value
			update_attack_range_hitbox_size()
			update_attack_range_display_size()
	get:
		return attack_radius_multiplier
var attack_crit_chance: float
var attack_crit_damage_multiplier: float


var actions : Array = []

func _ready() -> void:
	# setup process mode
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# set combat variables
	attack_damage = tower_stats.attack_damage
	attack_speed = tower_stats.attack_speed
	attack_radius = tower_stats.attack_radius	
	pierce = tower_stats.pierce
	attack_damage_multiplier = tower_stats.attack_damage_multiplier
	attack_speed_multiplier = tower_stats.attack_speed_multiplier
	attack_radius_multiplier = tower_stats.attack_radius_multplier
	attack_crit_chance = tower_stats.attack_crit_chance
	attack_crit_damage_multiplier = tower_stats.attack_crit_damage_multiplier
	
	# set attack radius
	update_attack_range_hitbox_size()
	
	# set attack radius display
	update_attack_range_display_size()
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


func _physics_process(_delta) -> void:
	pass


func place_tower() -> void:
	is_placed = true
	set_process(true)
	set_physics_process(true)
	disable_attack_range_display()
	
	#Add a CombatManager scene from resources
	#We take the scene out of a dictionary stored in tower_stats.gd
	#We refer to the entry of that dictionary by using an combat_manager_type variable (also from tower_stats.gd)
	var combat_manager_scene_path =  tower_stats.COMBAT_MANAGER_SCENES[tower_stats.combat_manager_type]
	var combat_manager_scene = load(combat_manager_scene_path)
	combat_manager = combat_manager_scene.instantiate()
	add_child(combat_manager)
	add_child(UPGRADES_MANAGER.instantiate())
	emit_signal("tower_placed",tower_stats)


func update_attack_range_display_size() -> void:
	var texture_size = attack_range_display.get_texture().get_size()
	var attack_range_scale_factor = (get_total_attack_radius() * 2.0) / texture_size.x
	attack_range_display.scale = Vector2(attack_range_scale_factor, attack_range_scale_factor)
	attack_range_display.material.set_shader_parameter("border_thickness",8.0/get_total_attack_radius())


func update_attack_range_hitbox_size() -> void:
	var attack_radius_shape = CircleShape2D.new()
	attack_radius_shape.radius = get_total_attack_radius()
	attack_range_hitbox.shape = attack_radius_shape


func update_attack_range_display_color_to_valid() -> void:
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_valid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_valid)


func update_attack_range_display_color_to_invalid() -> void:
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_invalid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_invalid)


func get_total_attack_damage() -> float:
	return attack_damage * attack_damage_multiplier


func get_total_attack_speed() -> float:
	return attack_speed * attack_speed_multiplier


func get_attack_delay() -> float:
	return 60/get_total_attack_speed()


func get_total_crit_damage() -> float:
	return get_total_attack_damage() * attack_crit_damage_multiplier


func get_total_attack_radius() -> float:
	return attack_radius * attack_radius_multiplier


func update_tower_stat_by_string_name(stat_name:String, value:float) -> void:
	var stat_value = get(stat_name)
	if stat_value:
		stat_value += value
		set(stat_name, stat_value)
	else:
		printerr("Not a valid tower stat: ", stat_name)

func disable_attack_range_display() -> void:
	attack_range_display.visible = false


func enable_attack_range_display() -> void:
	attack_range_display.visible = true


func _on_hitbox_area_entered(area) -> void:
	if area.is_in_group("TowerCollidable") && !is_placed:
		colliding_towers.append(area)
		placement_state = placement.invalid
		update_attack_range_display_color_to_invalid()
		
	#TBD gain aura buff on being in range of a tower with aura
	if area.is_in_group("TowerAttackRadius") && area != attack_range:
		print_debug("aura buff gained")

func _on_hitbox_area_exited(area) -> void:
	if area.is_in_group("TowerCollidable") && !is_placed:
		colliding_towers.pop_at(colliding_towers.find(area))
		if colliding_towers.is_empty():
			placement_state = placement.valid
			update_attack_range_display_color_to_valid()
	
	#TBD loose aura buff on being out of range of a tower with aura
	if area.is_in_group("TowerAttackRadius") && area != attack_range:
		print_debug("aura buff lost")
