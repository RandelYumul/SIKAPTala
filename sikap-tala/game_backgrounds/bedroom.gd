extends Node2D

@onready var glitch_bed = $GlitchBedroom
# --- NEW: Grab the reference to your audio node ---
@onready var door_sound = $DoorSound 


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
	# --- NEW: Play the sound when the player touches the door ---
	
	# Safety check: Make sure it's actually the player hitting the door, 
	# and not a random object or enemy falling into it!
	if body.is_in_group("player"):
		
		# Play the sound!
		BGMAct1.stop()
		if door_sound != null:
			door_sound.play(1.0)
			
			
		# (Optional) If you have code to change the scene or open the door, 
		# you would put that right here under the sound!
