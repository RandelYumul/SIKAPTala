extends Node2D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.play("yellow_choice")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "yellow_choice":
		print("Yellow choice animation finished")

		get_tree().change_scene_to_file("res://game_backgrounds/choices.tscn")
