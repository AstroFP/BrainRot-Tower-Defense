extends MarginContainer

@onready var wave_display_label = $WaveDisplayLabel

var wave_display_str = "Wave: "

# Called when the node enters the scene tree for the first time.
func _ready():
	wave_display_label.text = wave_display_str + "1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_wave_display(wave_number: int):
	if wave_number <= 0: wave_number = 1
	wave_display_label.text = wave_display_str + str(wave_number)
