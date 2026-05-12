extends Area2D

@onready var label = $InteractionLabel
@onready var door = $"../door" 
@onready var bedroom_puzzle = $"../bedroom_puzzle"
var done: bool = false

var drawer_count: int = 0 # Track how many times we interacted with the drawer

func _ready():
	label.hide()
	hide() 

func _process(_delta):
	if door and door.interact_count >= 1:
		show()

func _on_body_entered(body):
	if body.is_in_group("player") and door.interact_count >= 1:
		label.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		label.hide()

func _input(event):
	if label.visible and event.is_action_pressed("interact"):
		var alex_img = load("res://assets/pixel_art/pixel_folder/alex.PNG")
		var phone_img = load("res://assets/textbox assets/phone.png")
		
		var textbox = get_tree().get_first_node_in_group("textbox_group")
		var phone_box = get_tree().get_first_node_in_group("phone_textbox_group")
		
		if textbox:
			# --- FIRST INTERACTION ---
			if drawer_count == 0:
				var my_messages = [
					"It needs a passcode.... huh what’s that noise?",
					"My phone...yeah..forgot I had a phone..better answer that.",
					"Good morning, my dearest. Did you sleep well?",
					"I'm okay, Mom. Just waking up",
					"That’s good. Remember our little breathing rule for a calm day? Start with zero worries, take three deep breaths, two sips of water, and six minutes of silence.",
					"I have to go now, dear. Don't forget to check your drawer. I left a little something for you. Stay safe.",
					"Zero... three... two... six."
				]
				var my_portraits = [alex_img, alex_img, phone_img, alex_img, phone_img, phone_img, alex_img]
				
				textbox.start_chat(my_messages, my_portraits)
				
				# Wait a tiny bit then show the small box if you still want the overlap
				await get_tree().create_timer(0.1).timeout
				if phone_box:
					phone_box.start_chat(["You sound a bit tired. Did you have that dream again?"])
			
			# --- SECOND INTERACTION (and every time after) ---
			elif drawer_count > 0 and done == false  :
				# --- SECOND INTERACTION (The Puzzle) ---
				if bedroom_puzzle:
					bedroom_puzzle.show()
					# Optional: Stop player movement so they can type the code
					get_tree().call_group("player", "set_physics_process", false)        # This does the exact same thing
			
			elif drawer_count > 0 and done == true:
				var my_messages = [
					"I have the key already, lets try opening the door.",	
				]
				var my_portraits = [alex_img]
				textbox.start_chat(my_messages, my_portraits)  
				
			# Increment the count so the next press triggers the 'else' block
			drawer_count += 1
