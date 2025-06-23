extends ProgressBar

var parent
var max_healthbar_value
var min_healthbar_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	if parent.name == "HealthManager":
		max_healthbar_value = parent.max_health
		min_healthbar_value = parent.min_health
	else:
		push_error("parent is wrong")
	
	self.max_value = parent.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = parent.current_health
	if self.value >= max_healthbar_value || self.value <= min_healthbar_value:
		self.visible = false
	else:
		self.visible = true
