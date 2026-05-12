extends Node2D

func _ready():
	# Force it to be black and visible BEFORE playing the animation
	$fade_transition.modulate.a = 1.0
	$fade_transition.show()
	
	# Now play the fade out (Black -> Transparent)
	$fade_transition/AnimationPlayer.play("fade_out")
