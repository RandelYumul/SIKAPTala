extends Node2D

@onready var glitch_bed = $GlitchBedroom

func _ready():
	# Initial Fade Setup
	glitch_bed.hide()
	get_tree().call_group("player", "set_physics_process", false)
	$fade_transition.modulate.a = 1.0
	$fade_transition.show()
	$fade_transition/AnimationPlayer.play("fade_out")
	
	await $fade_transition/AnimationPlayer.animation_finished
	var alex_img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
	$textbox.start_chat(["Time to start the day"], alex_img)


func _on_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
