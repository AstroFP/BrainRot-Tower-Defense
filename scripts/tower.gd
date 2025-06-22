class_name Tower
extends Node2D

@export var tower_stats: TowerStats

@onready var tower_sprite = $TowerSprite
@onready var attack_range = $AttackRange
@onready var attack_range_hitbox = $AttackRange/AttackRangeHitbox
@onready var attack_range_display = $AttackRange/AttackRangeHitbox/AttackRangeDisplay
@onready var hitbox_collision_box = $Hitbox/HitboxCollisionBox

var is_placed = false
enum placement {valid = 0, invalid = 1}
var placement_state = placement.valid

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
	#tower_sprite.scale = Vector2(.25,.25)
	
	# set hitbox size
	var hitbox_radius = CapsuleShape2D.new()
	hitbox_radius.radius = tower_sprite.texture.get_size().x 
	hitbox_radius.height = tower_sprite.texture.get_size().y 
	hitbox_collision_box.shape = hitbox_radius
	
	# disable AI
	set_process(false)
	set_physics_process(false)
	#process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta):
	pass


func place_tower():
	is_placed = true
	set_process(true)
	set_physics_process(true)
	toggle_attack_range_display()

func update_attak_range_display_size():
	var texture_size = attack_range_display.get_texture().get_size()
	var scale_factor = (tower_stats.attack_radius * 2.0) / texture_size.x
	attack_range_display.scale = Vector2(scale_factor, scale_factor)


func update_attack_range_display_color_to_valid():
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_valid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_valid)


func update_attack_range_display_color_to_invalid():
	attack_range_display.material.set_shader_parameter("fill_color", tower_stats.attack_range_display_color_invalid)
	attack_range_display.material.set_shader_parameter("border_color", tower_stats.attack_range_display_border_color_invalid)


func toggle_attack_range_display():
	attack_range_display.visible = false if true else false

func _on_hitbox_area_entered(area):
	if area.get_name() == "Hitbox" && !is_placed:
		placement_state = placement.invalid
		update_attack_range_display_color_to_invalid()
		

func _on_hitbox_area_exited(area):
	if area.get_name() == "Hitbox" && !is_placed:
		placement_state = placement.valid
		update_attack_range_display_color_to_valid()
