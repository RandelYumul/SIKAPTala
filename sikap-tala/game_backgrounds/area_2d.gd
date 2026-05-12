extends Area2D

@onready var label = $InteractionLabel
var player_nearby: bool = false

func _ready():
	label.hide() # Keep the [E] hidden at start

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true  
		label.show() # Show [E] when close

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		label.hide() # Hide [E] when leaving

func _input(event):
	# Check if player is close AND pressed E
	if player_nearby and event.is_action_pressed("interact"):
		start_event()

func start_event():
	var img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
	
	# This finds the textbox no matter where it is in your scene
	var textbox = get_tree().get_first_node_in_group("textbox_group")
	
	if textbox:
		textbox.start_chat(["The door is locked....", "Maybe there’s a key in the drawer."], img)
	else:
		print("Error: Could not find the textbox node!")
