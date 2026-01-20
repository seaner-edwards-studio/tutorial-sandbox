extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta: float) -> void:
	### DEBUG - REMOVE THIS AND REPLACE WITH FIXED MOVEMENT
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	print("FIREBALL DIRECTION: " + str(direction))
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

# This needs to rotate the sprite based on the direction of the
# player. The player can be loaded in and values can be grabbed
# from it (I think). 
func handle_movement() -> void:
	print('TODO')
	
# This should detect if it collides with a slime and vanish
# Stretch goal is to add a new animation for "explosion" and
# replace this with that before removing.
func handle_collision() -> void:
	print('TODO')

# The cast sound is currently bound to the player. I think it should
# come from the spell itself. That way each spell knows its own
# sound and we can keep the player script cleaner.
func handle_sfx() -> void:
	print('TODO')
	
