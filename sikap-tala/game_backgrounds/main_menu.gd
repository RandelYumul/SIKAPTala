extends Node2D

var button_type = ""

func _on_button_pressed() -> void:
	transition_to("start")

func _on_settings_pressed() -> void:
	transition_to("settings")

# Helper function to avoid repeating code
func transition_to(type: String) -> void:
	button_type = type
	$fade_transition.show()
	$fade_transition/AnimationPlayer.play("fade_in")
	# Instead of a Timer node, you can use 'await' for cleaner code
	await $fade_transition/AnimationPlayer.animation_finished
	_on_fade_timer_timeout()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://game_backgrounds/blackscreen.tscn")
	elif button_type == "settings":
		# You probably want a different scene here later!
		get_tree().change_scene_to_file("res://game_backgrounds/bedroom.tscn")
