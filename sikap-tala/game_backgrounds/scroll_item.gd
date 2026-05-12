extends Area2D

@export var pink_mug: Node2D
@export var task_ui: Control

# --- NEW VARIABLES FOR THE SWAP ---
@export var real_player: Node2D
@export var static_player: Sprite2D 

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		if task_ui != null:
			task_ui.visible = true
			
		if pink_mug != null:
			pink_mug.visible = true
			
		# --- THE SWAP ---
		# Hide the real moving player, show the static flipped player
		if real_player != null:
			real_player.visible = false
		if static_player != null:
			static_player.visible = true
			
		self.visible = false

func toggle_click(can_click: bool):
	input_pickable = can_click
