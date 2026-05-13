extends Node2D

@onready var anim = $AnimationPlayer


func _ready() -> void:
	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.play("blue_choice")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "blue_choice":
		print("Blue choice animation finished")

		get_tree().change_scene_to_file("res://game_backgrounds/intro.tscn")
