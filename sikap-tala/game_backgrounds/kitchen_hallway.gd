extends Area2D

@onready var label = $InteractionLabel

var player_inside = false

func _ready() -> void:
	label.hide()

func _on_body_entered(body):
	if body.is_in_group("player") and Global.kitchen_win:
		player_inside = true
		label.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		label.hide()

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://game_backgrounds/hallway.tscn")
