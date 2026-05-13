extends Node2D

# References to your nodes based on the .tscn structure 
@onready var box1 = $Control/code1
@onready var box2 = $Control/code2
@onready var box3 = $Control/code3
@onready var box4 = $Control/code4
@onready var enter_button = $EnterButton
@onready var bedroom = get_node("../character_bedroom")
@onready var wrong_count := 0
@onready var glitch_playing = false 

const CORRECT_CODE = "0326"

func _ready():
	# Connect signals to handle auto-switching and digit limiting 
	box1.text_changed.connect(_on_text_changed.bind(box1, box2))
	box2.text_changed.connect(_on_text_changed.bind(box2, box3))
	box3.text_changed.connect(_on_text_changed.bind(box3, box4))
	box4.text_changed.connect(_on_text_changed.bind(box4, null))
	
	# Connect the submission button [cite: 9]
	enter_button.pressed.connect(_on_enter_pressed)

func _on_text_changed(new_text: String, current_box: LineEdit, next_box: LineEdit):
	# Only allow a single numeric digit 
	var regex = RegEx.new()
	regex.compile("[^0-9]")
	var filtered = regex.sub(new_text, "", true)
	
	if filtered.length() > 1:
		filtered = filtered.left(1)
	
	current_box.text = filtered
	
	# Automatically move focus to the next box 
	if filtered.length() == 1 and next_box != null:
		next_box.grab_focus()

func _on_enter_pressed():
	# Combine the values from all four boxes 
	var entered_code = box1.text + box2.text + box3.text + box4.text
	
	if entered_code == CORRECT_CODE:
		# 1. Handle the drawer state 
		var key_node = get_node("../key")
		var drawer_node = get_node("../drawer") 
		if drawer_node:
			drawer_node.done = true 
		
		# 2. Make the Key visible
		# If the key is a child of the current scene, use its name.
		# If it's a unique node, use %key
		if key_node:
			key_node.visible = true
			# If you want it to pop up or animate, you can trigger it here:
			# key_node.play_pickup_animation() 
		
		# 3. Notify the character node (using the group logic)
		get_tree().call_group("player", "obtain_key")

		# 4. Close puzzle and resume movement 
		hide() 
		get_tree().call_group("player", "set_physics_process", true) 
	else:
		wrong_count += 1
		print("Wrong code:", wrong_count)

		var glitch_player = get_node("../GlitchBedroom/Glitchplayer")

		if glitch_player and !glitch_playing:
			glitch_playing = true
			glitch_player.play("glitch")

			await glitch_player.animation_finished  # or animation_finished signal

			glitch_playing = false

		_reset_puzzle()

		if wrong_count >= 3:
			get_tree().change_scene_to_file("res://game_backgrounds/bedroom_gameover.tscn")

func _reset_puzzle():
	for box in [box1, box2, box3, box4]:
		box.clear() 
	box1.grab_focus()
