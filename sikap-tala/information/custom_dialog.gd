extends CanvasLayer
@onready var dialog_box = $DialogBox
var original_position: Vector2

@onready var text_label = $DialogBox/HBoxContainer/DialogText
@onready var portrait_rect = $DialogBox/HBoxContainer/Portrait

var dialogue_lines: Array = []
var current_line_index: int = 0
var is_typing: bool = false
var text_tween: Tween # We use a Tween for a buttery-smooth typing effect!

func _ready():
	hide() # Stay invisible until called
	original_position = dialog_box.position # Memorize where it started!

func start_dialog(lines: Array, portrait: Texture2D = null):
	dialogue_lines = lines
	current_line_index = 0
	
	if portrait != null:
		portrait_rect.texture = portrait
		portrait_rect.show()
	else:
		portrait_rect.hide()
		
	show()
	
	# Freeze the player using the group we set up earlier!
	get_tree().call_group("player", "set_physics_process", false)
	
	get_tree().call_group("clickable", "toggle_click", false)
	
	show_current_line()

func show_current_line():
	is_typing = true
	text_label.visible_characters = 0 # Hide all text initially
	text_label.text = dialogue_lines[current_line_index]
	
	# Calculate how long it takes to type based on word length (0.04 seconds per letter)
	var typing_duration = text_label.text.length() * 0.04 
	
	# Create the typing animation
	text_tween = create_tween()
	text_tween.tween_property(text_label, "visible_characters", text_label.text.length(), typing_duration)
	
	# Tell the script when the typing finishes
	text_tween.finished.connect(_on_typing_finished)

func _on_typing_finished():
	is_typing = false

func _input(event):
	if not visible: return # Do nothing if the box is hidden
	
	# Check for Space/Enter OR Left Click
	var next_input = event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed)
	
	if next_input:
		if is_typing:
			# Player clicked early -> Skip animation and show full text instantly
			text_tween.kill()
			text_label.visible_characters = -1 # -1 means show all characters
			is_typing = false
		else:
			# Typing is done -> Move to the next line
			current_line_index += 1
			if current_line_index < dialogue_lines.size():
				show_current_line()
			else:
				end_dialog()

func end_dialog():
	hide()
	portrait_rect.texture = null
	# Unfreeze the player!
	get_tree().call_group("player", "set_physics_process", true)
	
	get_tree().call_group("clickable", "toggle_click", true)
	dialog_box.position = original_position
	
	# Show the real character again
	get_tree().call_group("player", "set_visible", true)
	
	# Hide the "AlexSipping" and "AlexDistorted" images so they don't stay on screen
	get_tree().call_group("endings", "set_visible", false)

func move_box(new_position: Vector2):
	dialog_box.position = new_position
