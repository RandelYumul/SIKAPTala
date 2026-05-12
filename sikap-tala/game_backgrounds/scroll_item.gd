extends Area2D

# Your existing UI link
@export var task_ui: Control

# Add a new link for the mug
@export var pink_mug: Node2D 

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# 1. Show the large UI scroll
		if task_ui != null:
			task_ui.visible = true
			
		# 2. Show the pink mug
		if pink_mug != null:
			pink_mug.visible = true
			
		# 3. Hide THIS small closed scroll
		self.visible = false
