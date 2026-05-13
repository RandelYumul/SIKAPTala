extends Node2D

const BEDROOM_SCENE_PATH := "res://game_backgrounds/bedroom_alternate.tscn"

@onready var anim := $AnimationPlayer


func _ready() -> void:
	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.play("display")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "display":
		get_tree().change_scene_to_file(BEDROOM_SCENE_PATH)
