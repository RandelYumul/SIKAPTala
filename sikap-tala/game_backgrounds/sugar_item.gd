extends Area2D
var fall_speed: float = 250.0

func _process(delta):
	position.y += fall_speed * delta  # Move down continuously
	if position.y > 800:              # If it falls off the bottom of the screen
		queue_free()                  # Delete it to save memory
