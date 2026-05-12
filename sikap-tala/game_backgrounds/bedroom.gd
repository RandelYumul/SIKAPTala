extends Node2D

func _ready():
	# Initial Fade Setup
	$fade_transition.modulate.a = 1.0
	$fade_transition.show()
	$fade_transition/AnimationPlayer.play("fade_out")
	
	await $fade_transition/AnimationPlayer.animation_finished
	var alex_img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
	$textbox.start_chat(["Time to start the day"], alex_img)
