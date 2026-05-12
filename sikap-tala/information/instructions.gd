extends Node2D

# Replace this with the actual path to your bedroom scene
var next_scene_path = "res://game_backgrounds/bedroom.tscn"

func _input(event: InputEvent) -> void:
	# "ui_accept" is the default action for Enter and Space in Godot
	if event.is_action_pressed("ui_accept"):
		proceed()

func proceed() -> void:
	# If you have your fade_transition in this scene, play it first
	if has_node("fade_transition"):
		var anim = $fade_transition/AnimationPlayer
		$fade_transition.show()
		anim.play("fade_in")
		await anim.animation_finished
	
	# Change to the bedroom
	get_tree().change_scene_to_file(next_scene_path)
