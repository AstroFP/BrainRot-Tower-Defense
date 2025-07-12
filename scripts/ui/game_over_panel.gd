class_name GameOverPanel
extends MarginContainer

@onready var game_over_wave = $GameOverPanelBg/GameOverPanelItemsWrapper/GameOverPanelItems/GameOverWave

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_game_over_panel(waves_survived: int):
	if waves_survived == 0: waves_survived = 1
	game_over_wave.text += str(waves_survived)
	visible = true


func _on_play_again_btn_pressed():
	await RenderingServer.frame_post_draw
	get_tree().reload_current_scene()


func _on_replay_last_wave_btn_pressed():
	pass # Replace with function body.


func _on_exitbtn_pressed():
	pass # Replace with function body.
