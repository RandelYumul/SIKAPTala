extends Area2D

@onready var label = $InteractionLabel
@onready var anim = $AnimationPlayer
@onready var bathsign = $"../BathroomSign1"
@onready var bathsign2 = $"../BathroomSign2"
@onready var tobath = $"../tobathroom"

var player_inside = false
var transitioning = false

func _ready() -> void:
	label.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		label.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		label.hide()

func _process(delta: float) -> void:
	if transitioning:
		return

	if player_inside and Input.is_action_just_pressed("interact"):
		start_transition()

func start_transition():
	transitioning = true

	# Hide interaction UI
	label.hide()
	bathsign.hide()

	# OPTIONAL: disable player movement
	get_tree().call_group("player", "set_physics_process", false)

	# Play animation
	anim.play("glitch")
	
	await anim.animation_finished
	bathsign2.show()
	tobath.show()
	
	get_tree().call_group("player", "set_physics_process", true)
	
	set_deferred("monitoring", false)
