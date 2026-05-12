extends Node2D

@export var custom_dialog: CanvasLayer
@export var portrait_image: Texture2D

func _ready():
	if custom_dialog != null:
		var lines = [
			"Hm..? A note...?",
            "I don't remember leaving anything on the counter."
		]
		custom_dialog.start_dialog(lines, portrait_image)
