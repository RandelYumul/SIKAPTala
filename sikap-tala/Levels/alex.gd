extends CharacterBody2D

@export var speed: float = 400.0

func _ready() -> void:
	add_to_group("Player") # make sure alex is in the Player group

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

# Trigger when entering the bathroom area
func _on_event_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var popup = get_node("/root/Bathroom/event_trigger/WashFaceOption")
		popup.show()
