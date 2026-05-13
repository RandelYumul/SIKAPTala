extends Node2D

@onready var anim = $AnimationPlayer


func _ready() -> void:
	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.play("bedroom_chaos")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "bedroom_chaos":
		print("Game over animation finished")

		get_tree().change_scene_to_file("res://game_backgrounds/game_over.tscn")
