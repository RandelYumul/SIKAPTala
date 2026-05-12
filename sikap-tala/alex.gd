extends CharacterBody2D # Must change from Node2D to CharacterBody2D

@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right") # Cleaner way to get -1, 0, or 1

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# This function handles the collision logic automatically
	move_and_slide()
