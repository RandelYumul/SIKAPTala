extends ColorRect

func _ready() -> void:
	show()
	# Ensure the node can actually process input
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# Check for "Enter" specifically
	if event.is_action_pressed("ui_accept"):
		print("Enter pressed! Changing scene...") # This helps you debug in the Output console
		var error = get_tree().change_scene_to_file("res://game_backgrounds/menu.tscn")
		
		if error != OK:
			print("Error: Could not find menu.tscn. Check your file path!")
