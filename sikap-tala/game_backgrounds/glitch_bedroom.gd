extends Node2D

@onready var anim = $AnimationPlayer
@onready var alex = $alex
@onready var mother = $RichTextLabel3
@onready var system = $RichTextLabel4
@onready var whispers = $RichTextLabel5
@onready var gb2 = $Glitchbedroom2

var textbox = null

func _ready() -> void:
	alex.hide()
	mother.hide()
	gb2.hide()
	system.hide()
	whispers.hide()

	textbox = get_tree().get_first_node_in_group("textbox_group")

	print("AnimationPlayer:", anim)

	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.play("glitch_bedroom")


func _on_animation_finished(anim_name: String) -> void:
	print("Animation finished:", anim_name)

	# ─────────────────────────────
	# FIRST ANIMATION
	# ─────────────────────────────
	if anim_name == "glitch_bedroom":
		print("MATCHED GLITCH ANIMATION")

		alex.show()

		textbox = get_tree().get_first_node_in_group("textbox_group")

		var alex_img = load("res://assets/pixel_art/pixel_folder/alex.PNG")

		if textbox:
			var my_messages = [
				"Why is my drawer open...?",
				"Where is my phone...?"
			]

			var my_portraits = [
				alex_img,
				alex_img
			]

			get_tree().call_group("player", "set_physics_process", false)

			if not textbox.is_connected("dialogue_finished", _on_chat_finished):
				textbox.dialogue_finished.connect(_on_chat_finished)

			textbox.start_chat(my_messages, my_portraits)

	# ─────────────────────────────
	# AFTER REPLY ANIMATION
	# ─────────────────────────────
	elif anim_name == "reply":
		print("Reply animation finished")
		go_to_scene("res://game_backgrounds/choices.tscn")


# ─────────────────────────────
# AFTER DIALOGUE
# ─────────────────────────────
func _on_chat_finished() -> void:
	print("Dialogue finished → playing reply animation")

	anim.play("reply")
	
func go_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
