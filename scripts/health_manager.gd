extends Node2D

#TODO
#test all added features
#delete/comment out the testing button

signal health_changed(new_health_value)
signal max_health_changed(new_max_health_value)
signal dead

var max_health := 200
var min_health := 0
var current_health
var button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health*0.2
	health_changed.emit(current_health)
	
	button = get_tree().root.get_node("TestLevel").get_node("TestButton")
	if button:
		print_debug(button)
	else:
		print_debug("XD")
	button.pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func take_damage(damage_ammount):
	if(damage_ammount<0):
		printerr("Error: damage is negative: %d" % damage_ammount)
		printerr("The damage will not be applied")
		return
	
	if(current_health <= damage_ammount):
		#for consistency sake we keep health at min not at random negative number
		current_health = min_health
		dead.emit()
	else:
		current_health -= damage_ammount
	
	health_changed.emit(current_health)


func heal(heal_ammount):
	if(heal_ammount<0):
		printerr("Error: heal is negative: %d" % heal_ammount)
		printerr("The heal will not be applied")
		return
	
	if(heal_ammount + current_health >= max_health):
		#preventing overheal with this
		current_health = max_health
	else:
		current_health += heal_ammount
	
	print_debug("Current health %d" % self.current_health)
	health_changed.emit(current_health)


func set_new_max_health(new_max_health):
	if(new_max_health<1):
		printerr("Error: cannot set max_health under 1")
		printerr("the ammount specified was: %d" % new_max_health)
		return
	
	#trunking hp if needed
	if(current_health-new_max_health>0):
		print("The current health of %s got trunked from %d to %d"
		 %[get_parent().name, current_health, new_max_health])
		current_health = new_max_health
		
	max_health = new_max_health
	max_health_changed.emit(max_health)


func reset_health():
	current_health = max_health
	health_changed.emit(current_health)


func _on_button_pressed():
	self.set_new_max_health(-500)
