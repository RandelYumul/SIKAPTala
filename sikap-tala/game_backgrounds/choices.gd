extends Sprite2D

@onready var button1 = $button1
@onready var button2 = $button2
@onready var button3 = $button3


func _ready() -> void:
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)


func _on_button1_pressed() -> void:
	get_tree().change_scene_to_file("res://game_backgrounds/bedroom.tscn")


func _on_button2_pressed() -> void:
	get_tree().change_scene_to_file("res://game_backgrounds/hallway.tscn")


func _on_button3_pressed() -> void:
	get_tree().change_scene_to_file("res://game_backgrounds/kitchen.tscn")
