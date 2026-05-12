extends CharacterBody2D

@export var speed: float = 400.0

var facing := "right"  # track last direction

func _ready() -> void:
	add_to_group("Player") # make sure alex is in the Player group

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = direction * speed

		# Update facing direction
		if direction < 0:
			facing = "left"
			$AnimatedSprite2D.play("walk_left")
		else:
			facing = "right"
			$AnimatedSprite2D.play("walk_right")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

		# Idle animation based on last facing
		if facing == "left":
			$AnimatedSprite2D.play("idle_left")
		else:
			$AnimatedSprite2D.play("idle_right")

	move_and_slide()

# Trigger when entering the bathroom area
func _on_event_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var popup = get_node("/root/Bathroom/event_trigger/WashFaceOption")
		popup.show()
