extends Node2D

@export var typing_speed: float = 0.05
@onready var label = $Label
@onready var portrait = $Portrait

var messages: Array = []
var current_index: int = 0
var is_typing: bool = false

func _ready():
	hide() # Keep hidden until start_chat is called

func start_chat(text_array: Array, portrait_texture: Texture2D = null):
	get_tree().call_group("player", "set_physics_process", false)
	messages = text_array
	current_index = 0
	print("Loading image: ", portrait_texture) # If this prints 'Null', the path is wrong
	
	if portrait_texture:
		portrait.texture = portrait_texture
		portrait.show()
	else:
		portrait.hide() # Hide if no image is sent
		
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
				portrait.texture = null
				get_tree().call_group("player", "set_physics_process", true)

func display_message():
	is_typing = true
	label.text = ""
	
	for character in messages[current_index]:
		if not is_typing: 
			label.text = messages[current_index] # Show full text
			break
		label.text += character
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
