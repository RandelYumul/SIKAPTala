extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Start the text animation as soon as the scene loads
	# Based on your previous setup, ensure this animation name matches exactly [cite: 4, 9]
	anim_player.play("text_intro")
	
	# Wait for the animation to finish
	await anim_player.animation_finished
	
	# After the animation is done, you can either auto-change 
	# or wait for the user to see the "Press Enter" prompt
	# change_to_bedroom() 

func _input(event: InputEvent) -> void:
	# Listen for the Enter key (ui_accept) to proceed manually
	if event.is_action_pressed("ui_accept"):
		change_to_bedroom()

func change_to_bedroom() -> void:
	# If you have a fade_transition, play it first [cite: 4, 8]
	if has_node("fade_transition"):
		$fade_transition.show()
		$fade_transition/AnimationPlayer.play("fade_in")
		await $fade_transition/AnimationPlayer.animation_finished
	
	# Move to the bedroom scene 
	get_tree().change_scene_to_file("res://game_backgrounds/bedroom.tscn")
