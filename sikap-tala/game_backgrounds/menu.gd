extends Node2D

@onready var anim = get_node_or_null("fade_transition/AnimationPlayer")

@onready var stay_btn = get_node_or_null("Control/stay_button")
@onready var wake_btn = get_node_or_null("Control/wake_up_button")
@onready var forget_btn = get_node_or_null("Control/forget_button")

func _ready():
	if anim:
		anim.play("fade_out")

	if stay_btn:
		stay_btn.pressed.connect(_on_stay_pressed)

	if wake_btn:
		wake_btn.pressed.connect(_on_wake_pressed)

	if forget_btn:
		forget_btn.pressed.connect(_on_forget_pressed)


# ─────────────────────────────
# BUTTON ACTIONS
# ─────────────────────────────

func _on_stay_pressed():
	go_to_scene("res://game_backgrounds/glitch_bedroom.tscn")

func _on_wake_pressed():
	go_to_scene("res://game_backgrounds/bedroom.tscn")

func _on_forget_pressed():
	go_to_scene("res://game_backgrounds/bedroom.tscn")


# ─────────────────────────────
# TRANSITION FUNCTION
# ─────────────────────────────

func go_to_scene(path: String):
	get_tree().call_group("player", "set_physics_process", false)

	if anim:
		anim.play("fade_in")
		await anim.animation_finished

	get_tree().change_scene_to_file(path)
