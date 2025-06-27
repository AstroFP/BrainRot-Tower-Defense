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
var current_cash: int

func update_current_lives(amount: int):
	current_lives += amount
	if current_lives > max_lives:
		current_lives = max_lives
	
	if current_lives <= min_lives:
		emit_signal("game_over")

func update_current_cash(amount: int):
	current_cash += amount
	if current_cash > max_cash:
		current_cash = max_cash
	
	if current_cash < min_cash:
		current_cash = min_cash
