extends CanvasGroup

func _ready() -> void:
	hide() # start hidden

func _on_WashYourFace_pressed() -> void:
	# Example: change to next scene
	get_tree().change_scene_to_file("res://NextScene.tscn")
