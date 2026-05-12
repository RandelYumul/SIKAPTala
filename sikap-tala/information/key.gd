extends Node2D

var checked = false

func _process(delta: float) -> void:
	if visible and Input.is_action_just_pressed("ui_accept"):
		Global.has_key = true
		print(Global.has_key)
		hide()
		
