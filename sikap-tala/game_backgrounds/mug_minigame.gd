extends Area2D

# --- 1. CORE MINIGAME LINKS ---
@export var player_character: CharacterBody2D
@export var timer_label: Label         
@export var mini_clock_node: Sprite2D  
@export var task_ui: Control           

# --- 2. SPAWNER LINKS ---
@export var sugar_scene: PackedScene   
@export var bubble_scene: PackedScene  

# --- 3. ENDING SCENE LINKS ---
@export var desk_node: Sprite2D
@export var alex_sipping: Sprite2D
@export var chaos_bg: Sprite2D
@export var alex_distorted: Sprite2D

@export var speed: float = 400.0       

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
	
	# Hide the big scroll UI
	if task_ui != null:
		task_ui.visible = false
		
	# Show the clock
	if mini_clock_node != null:
		mini_clock_node.visible = true
		
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
	
	# --- NEW: DESTROY ALL FALLING ITEMS ---
	# This tells every node in the "sugar" and "bubble" groups to run queue_free()
	get_tree().call_group("sugar", "queue_free")
	get_tree().call_group("bubble", "queue_free")
	
	# 1. Hide the minigame elements
	if mini_clock_node != null:
		mini_clock_node.visible = false
	self.visible = false # Hides the PinkMug
	
	# 2. Hide the normal room elements
	if player_character != null:
		player_character.visible = false
	if desk_node != null:
		desk_node.visible = false
		
	# 3. Check Win/Loss Condition
	if score >= 12:
		# WIN: Show the calm sipping image
		print("WIN! Score: ", score)
		if alex_sipping != null:
			alex_sipping.visible = true
			
	else:
		# LOSS: Show the chaos state and distorted perception
		print("LOSS! Score: ", score)
		if chaos_bg != null:
			chaos_bg.visible = true
		if alex_distorted != null:
			alex_distorted.visible = true
