extends Area2D

@onready var label = $InteractionLabel
var interact_count: int = 0 

func _ready():
	label.hide()
	add_to_group("door_group") # Safety for finding the node

func _on_body_entered(body):
	if body.is_in_group("player"):
		label.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		label.hide()

func _input(event):
	if label.visible and event.is_action_pressed("interact"):
		start_event()

func start_event():
	var img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
	var textbox = get_tree().get_first_node_in_group("textbox_group")
	
	if not textbox: return

	if interact_count == 0:
		# Two messages, so we send a list of two images
		get_tree().call_group("player", "set_physics_process", false)
		textbox.start_chat(
			["The door is locked...", "Maybe there’s a key in the drawer."], 
			[img, img] 
		)
	else:
		# One message, so we send a list of one image
		get_tree().call_group("player", "set_physics_process", false)
		textbox.start_chat(
			["Still locked. I need that key."], 
			[img]
		)
	
	interact_count += 1 
