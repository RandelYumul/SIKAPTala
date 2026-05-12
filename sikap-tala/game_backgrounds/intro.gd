extends AnimatedSprite2D

# 1. Path to your next scene
var intro_redirect_path = "res://Levels/glitch_bathroom.tscn"

func _ready() -> void:
	# 2. Start the animation
	play("default") 
	
	# 3. Create a one-shot timer for 2 seconds
	# This tells Godot: "Wait 2 seconds, then continue"
	await get_tree().create_timer(2.0).timeout
	
	# 4. Change the scene
	change_scene()

func _input(event: InputEvent) -> void:
	# OPTIONAL: Let the player skip by pressing Enter
	if event.is_action_pressed("ui_accept"):
		change_scene()

func change_scene() -> void:
	# Play fade if you have it
	if has_node("fade_transition"):
		$fade_transition/AnimationPlayer.play("fade_in")
		await $fade_transition/AnimationPlayer.animation_finished
		
	get_tree().change_scene_to_file(intro_redirect_path)
