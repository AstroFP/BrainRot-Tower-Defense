class_name LevelResources
extends Resource

signal game_over

# lives
var min_lives := 0
var max_lives := 999_999_999
var current_lives: int

# cash
var min_cash := -999_999_999 # if we'd like to have a functionality to get in debt else set to 0
var max_cash := 999_999_999
var currnet_cash: int

func update_current_lives(amount: int):
	current_lives += clamp(amount, min_lives-1, max_lives+1)
	if current_lives <= min_lives:
		emit_signal("game_over")

func update_current_cash(amount: int):
	currnet_cash += clamp(amount, min_cash-1, max_cash+1)
