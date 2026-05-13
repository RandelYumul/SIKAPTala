extends Area2D

@onready var label = $InteractionLabel
@onready var file = $"../File"
@onready var next_popup = $"../OpenFile"
@onready var textbox = get_tree().get_first_node_in_group("textbox_group")

var reading_file := false


func _ready():
	label.hide()
	file.hide()
	next_popup.hide()

	add_to_group("door_group")


func _on_body_entered(body):
	if body.is_in_group("player"):
		label.show()


func _on_body_exited(body):
	if body.is_in_group("player"):
		label.hide()


func _input(event):

	# OPEN FILE
	if label.visible and event.is_action_pressed("interact") and not reading_file:
		start_event()

	# CLOSE FILE + NEXT STEP
	elif reading_file and event.is_action_pressed("ui_accept"):
		file.hide()

		# STEP 1: show next popup
		next_popup.show()

		# STEP 2: show textbox AFTER file closes
		if textbox:
			textbox.show()
			# optional example dialogue trigger
			# textbox.start_chat(["Something feels off..."])

		reading_file = false


func start_event():
	file.show()
	reading_file = true
