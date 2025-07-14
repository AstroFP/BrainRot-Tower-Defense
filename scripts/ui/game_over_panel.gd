class_name GameOverPanel
extends MarginContainer

@onready var popup_menu: PanelContainer = $"../PopupMenu"
@onready var game_over_animation_player: AnimationPlayer = $GameOverAnimationPlayer
@onready var game_over_wave: Label = $GameOverPanel/GameOverPanelItemsWrapper/GameOverPanelItemsInnerBg/GameOverPanelItemsContainer/GameOverPanelItems/GameOverWaveWrapper/GameOverWaveBg/GameOverWave


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
	game_over_animation_player.play("Open")


func _on_play_again_btn_pressed():
	popup_menu.setup_menu("Play again", "Are you sure you wish to replay the level?", get_tree().reload_current_scene)
	popup_menu.show_menu()


func _on_replay_last_wave_btn_pressed():
	pass # Replace with function body.


func _on_exit_btn_pressed() -> void:
	pass # Replace with function body.
