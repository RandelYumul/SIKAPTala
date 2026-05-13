extends Area2D

# --- 1. CORE MINIGAME LINKS ---
@export var player_character: CharacterBody2D
@export var timer_label: Label         
@export var mini_clock_node: Sprite2D  
@export var task_ui: Control           

# --- 2. SPAWNER LINKS ---
@export var sugar_scene: PackedScene   
@export var bubble_scene: PackedScene  
@export var goal_text: Label

# --- 3. ENDING SCENE LINKS ---
@export var desk_node: Sprite2D
@export var alex_sipping: Sprite2D
@export var chaos_bg: Sprite2D
@export var alex_distorted: Sprite2D
@export var static_player: Sprite2D    # <-- NEW: Link to the fake flipped character

@export var speed: float = 400.0       

# --- 4. DIALOGUE LINKS ---
@export var custom_dialog: CanvasLayer
@export var portrait_image: Texture2D 

@export var ambient_light: CanvasModulate

# --- GAME VARIABLES ---
var minigame_active: bool = false
var time_left: float
var score: int = 0
var spawn_timer: float = 0.0
var spawn_rate: float = 0.8            

func _ready():
	# Set display to 30 seconds initially
	time_left = 30.0 
	update_clock_display()

func _on_input_event(viewport, event, shape_idx):
	# Detect Left Click to start
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not minigame_active:
			start_minigame()

func start_minigame():
	minigame_active = true
	time_left = 30.0 
	score = 0 
	
	scale = Vector2(1.1, 1.0)
	
	# Hide the big scroll UI
	if task_ui != null:
		task_ui.visible = false
		
	# Show the clock
	if mini_clock_node != null:
		mini_clock_node.visible = true
		
	if goal_text != null:
		goal_text.visible = true
		
	# Freeze the player
	if player_character != null:
		player_character.set_physics_process(false) 

func _process(delta):
	if minigame_active:
		# --- MOVEMENT LOGIC ---
		var direction = Vector2.ZERO
		if Input.is_key_pressed(KEY_W): direction.y -= 1
		if Input.is_key_pressed(KEY_S): direction.y += 1
		if Input.is_key_pressed(KEY_A): direction.x -= 1
		if Input.is_key_pressed(KEY_D): direction.x += 1
			
		if direction.length() > 0:
			direction = direction.normalized()
		position += direction * speed * delta

		# --- SPAWNER LOGIC ---
		spawn_timer += delta
		if spawn_timer >= spawn_rate:
			spawn_timer = 0.0
			spawn_item()

		# --- TIMER LOGIC ---
		if time_left > 0:
			time_left -= delta 
			update_clock_display()
		else:
			end_minigame() 

func spawn_item():
	if sugar_scene == null or bubble_scene == null: return
	
	# 70% chance for sugar, 30% chance for a bubble
	var is_sugar = randf() > 0.3 
	var item = sugar_scene.instantiate() if is_sugar else bubble_scene.instantiate()
	
	# Spawn at a random X coordinate above the screen
	var random_x = randf_range(100, 1050) 
	item.position = Vector2(random_x, -50) 
	
	get_parent().add_child(item)

func _on_area_entered(area):
	if not minigame_active: return
	
	# Catching Sugar
	if area.is_in_group("sugar"):
		score += 1
		print("Got Sugar! Score: ", score)
		area.queue_free() 
		
	# Catching Bubbles
	elif area.is_in_group("bubble"):
		time_left -= 3.0 # Lose 3 seconds!
		print("Hit Bubble! Lost Time!")
		area.queue_free() 
		update_clock_display()

func update_clock_display():
	if timer_label != null:
		var seconds = max(int(time_left), 0) 
		timer_label.text = "0:%02d" % seconds

func end_minigame():
	minigame_active = false
	time_left = 0
	update_clock_display()
	
	# --- DESTROY ALL FALLING ITEMS ---
	# This tells every node in the "sugar" and "bubble" groups to run queue_free()
	get_tree().call_group("sugar", "queue_free")
	get_tree().call_group("bubble", "queue_free")
	
	# 1. Hide the minigame elements
	if mini_clock_node != null:
		mini_clock_node.visible = false
		
	if goal_text != null:
		goal_text.visible = false
	self.visible = false # Hides the PinkMug
	
	# 2. Hide the normal room elements
	if player_character != null:
		player_character.visible = false
	if static_player != null:
		static_player.visible = false # <-- NEW: Hides the static player as well
	if desk_node != null:
		desk_node.visible = false
		
	# 3. Check Win/Loss Condition
	if score >= 12:
		# WIN: Show the calm sipping image
		print("WIN! Score: ", score)
		Global.kitchen_win = true
		if alex_sipping != null:
			alex_sipping.visible = true
		
		if custom_dialog != null:
			
			custom_dialog.move_box(Vector2(200, 480))
			var win_lines = [
				"Whew... much better.",
				"Hey, thank you so much for the coffee!"
			]
			custom_dialog.start_dialog(win_lines, portrait_image)
	else:
		# LOSS: Show the chaos state and distorted perception
		print("LOSS! Score: ", score)
		if chaos_bg != null:
			chaos_bg.visible = true
		if alex_distorted != null:
			alex_distorted.visible = true
			
		# --- NEW: DARKNESS TRANSITION ---
		if ambient_light != null:
			var light_sequence = create_tween()
			
			# Step 1: Gradually turn the room a dark, murky purple over 2 seconds
			light_sequence.tween_property(ambient_light, "color", Color(0.2, 0.1, 0.3, 1.0), 2.0)
			
			# Step 2: The Glitch! A few rapid snaps to near-black and back
			light_sequence.tween_property(ambient_light, "color", Color(0.05, 0.05, 0.1, 1.0), 0.1)
			light_sequence.tween_property(ambient_light, "color", Color(0.2, 0.1, 0.3, 1.0), 0.1)
			light_sequence.tween_property(ambient_light, "color", Color(0.05, 0.05, 0.1, 1.0), 0.15)
			light_sequence.tween_property(ambient_light, "color", Color(0.3, 0.2, 0.4, 1.0), 0.1)
			light_sequence.tween_property(ambient_light, "color", Color(0.05, 0.05, 0.1, 1.0), 0.2)
			
			# Step 3: Settle into a dim, creepy lighting over 1.5 seconds 
			# Color(0.5, 0.5, 0.6) is about 50% brightness with a slight blue/cold tint
			light_sequence.tween_property(ambient_light, "color", Color(0.5, 0.5, 0.6, 1.0), 1.5)
			# WAIT for tween to finish before switching scene
			await light_sequence.finished

		# --- GO TO GAME OVER SCENE ---
		get_tree().change_scene_to_file("res://game_backgrounds/game_over.tscn")
# --- NEW: FLICKER HELPER FUNCTIONS ---
func _start_flicker():
	# This creates a repeating flicker effect
	var flicker_timer = get_tree().create_timer(randf_range(0.1, 0.5))
	flicker_timer.timeout.connect(_toggle_flicker)

func _toggle_flicker():
	if minigame_active: return # Stop flickering if game restarts
	
	if ambient_light != null:
		# Randomly jump between dark and slightly darker to look like a dying light
		if ambient_light.color.v > 0.1:
			ambient_light.color = Color(0.05, 0.05, 0.1, 1.0) # Near black
		else:
			ambient_light.color = Color(0.2, 0.1, 0.3, 1.0) # Dark purple
			
		# Repeat the process
		_start_flicker()


func toggle_click(can_click: bool):
	input_pickable = can_click
