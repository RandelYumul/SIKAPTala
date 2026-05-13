extends Node2D

@onready var glitch_bed = $GlitchBedroom

func _ready():
	$fade_transition.modulate.a = 1.0
	$fade_transition.show()
	$fade_transition/AnimationPlayer.play("fade_out")

	await $fade_transition/AnimationPlayer.animation_finished

	var alex_img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
	$textbox.start_chat(["Back here again??"], alex_img)

	# wait until dialogue finishes
	await $textbox.dialogue_finished

	get_tree().change_scene_to_file("res://game_backgrounds/game_over.tscn")


func _on_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
