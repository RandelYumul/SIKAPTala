extends Node2D

# The path to your next scene. Adjust this to match your actual file structure.
const BEDROOM_SCENE_PATH = "res://game_backgrounds/bedroom.tscn"

func _process(_delta): 
	# 1. Logic for flipping the sprite (from your previous question)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		%AnimatedSprite2D.flip_h = false
	elif direction < 0:
		%AnimatedSprite2D.flip_h = true

	# 2. Logic for proceeding to the next scene
	# We use 'ui_accept' (mapped to Enter by default) 
	# and check if the 'enter' prompt is actually visible to the player.
	if Input.is_action_just_pressed("ui_accept"):
		proceed_to_next_scene()

func proceed_to_next_scene():
	# This changes the scene to the bedroom
	var error = get_tree().change_scene_to_file(BEDROOM_SCENE_PATH)
	
	if error != OK:
		print("Error: Could not find the bedroom scene at ", BEDROOM_SCENE_PATH)
