extends ProgressBar

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	if parent.name == "HealthManager":
		max_value = parent.max_health
		min_value = parent.min_health
		parent.health_changed.connect(_on_health_changed)
	else:
		push_error("parent for healthbar is wrong!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_health_changed(new_health_value):
	value = new_health_value
	if value >= max_value || value <= min_value:
		visible = false
	else:
		visible = true
