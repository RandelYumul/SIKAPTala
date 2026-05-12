extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$fade_transition/AnimationPlayer.play("fade_out")
