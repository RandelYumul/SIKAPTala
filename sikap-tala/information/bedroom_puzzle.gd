extends Node2D

# References to your nodes based on the .tscn structure 
@onready var box1 = $Control/code1
@onready var box2 = $Control/code2
@onready var box3 = $Control/code3
@onready var box4 = $Control/code4
@onready var enter_button = $EnterButton

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
			# Look for the drawer node. 
			# If it's a sibling, use "../DrawerName"
			var drawer_node = get_node("../drawer") 
			
			if drawer_node:
				drawer_node.done = true
				hide()
				get_tree().call_group("player", "set_physics_process", true)
	else:
		print("Wrong code, try again.")
		_reset_puzzle()

func _reset_puzzle():
	for box in [box1, box2, box3, box4]:
		box.clear() 
	box1.grab_focus()
