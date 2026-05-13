extends Node2D

signal dialogue_finished

@export var typing_speed: float = 0.05
@onready var label = $Label
@onready var portrait = $Portrait

var messages: Array = []
var portraits: Array = []
var current_index: int = 0
var is_typing: bool = false

func _ready():
	hide() # Keep hidden until start_chat is called
	add_to_group("textbox_group")

func start_chat(text_array: Array, portrait_data = []):
	# This checks: if the user sent ONE image instead of a LIST, 
	# it automatically puts it into a list for you.
	if portrait_data is Texture2D:
		portraits = [portrait_data]
	else:
		portraits = portrait_data
		
	messages = text_array
	current_index = 0
	show()
	display_message()

func _input(event):
	if not visible: return
	
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			is_typing = false # This skips the animation
		else:
			current_index += 1
			if current_index < messages.size():
				display_message()
			else:
				hide()
				dialogue_finished.emit()
				portrait.texture = null
				if is_inside_tree():
					get_tree().call_group("player", "set_physics_process", true)

func display_message():
	is_typing = true
	label.text = ""
	
	# Update the image to match the current message index
	if current_index < portraits.size() and portraits[current_index] != null:
		portrait.texture = portraits[current_index]
		portrait.show()
	else:
		portrait.hide()
	
	for character in messages[current_index]:
		if not is_typing: 
			label.text = messages[current_index]
			break
		label.text += character
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
