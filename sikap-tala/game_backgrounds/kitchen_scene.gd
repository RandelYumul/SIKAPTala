extends Node2D

@export var custom_dialog: CanvasLayer
@export var portrait_image: Texture2D
@onready var act_2: AudioStreamPlayer = $Act2

func _ready():
	BGMAct1.stop()
	act_2.play()
	if custom_dialog != null:
		var lines = [
			"Hm..? A note...?",
            "I don't remember leaving anything on the counter."
		]
		custom_dialog.start_dialog(lines, portrait_image)
