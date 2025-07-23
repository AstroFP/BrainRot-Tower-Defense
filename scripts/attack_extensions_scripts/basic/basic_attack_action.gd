class_name BasicAction
extends Resource

var action_function: Callable

var updates: Array[String] = ["none", "Update 1", "Update 2"]

func _init(action_func:Callable, name:String) -> void:
	resource_name = name
	action_function = action_func


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func set_action_function(action_func:Callable) -> void:
	action_function = action_func


func execute(params:Dictionary) -> void:
		action_function.call(params)
