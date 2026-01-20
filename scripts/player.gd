extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $animation
@onready var cast_fire_1: AudioStreamPlayer2D = $cast_fire_1

const SPEED = 130.0
var last_direction: Vector2 = Vector2.DOWN
var is_casting: bool = false
var spellcast_hitbox_offset: Vector2

func _ready() -> void:
	# Initialize hitbox offset
	print("INFO: player initialized")


func _physics_process(_delta: float) -> void:	
	if Input.is_action_just_pressed("cast_spell") and not is_casting:
		print("PROCESS")
		cast_spell()
	
	if is_casting:
		velocity = Vector2.ZERO
		return
	
	handle_movement()
	process_animation()
	move_and_slide()
	
####################################################################################################
# Animations 
####################################################################################################

# Get the input direction and handle the movement
func handle_movement() -> void:	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction		
	else:
		velocity = Vector2.ZERO
	
# Determines if movement animation is walk or idle
func process_animation() -> void:
	if is_casting:
		return
	if velocity != Vector2.ZERO:
		play_animation(last_direction, "move")
	else:
		play_animation(last_direction, "idle")
		
# Determines the animation direction, relying on prefix to select animation type
func play_animation(dir: Vector2, prefix: String) -> void:
	if dir.x > 0:
		animation.play(prefix + "_right")
	elif dir.x < 0:
		animation.play(prefix + "_left")
	elif dir.y > 0:
		animation.play(prefix + "_down")
	elif dir.y < 0:
		animation.play(prefix + "_up")

####################################################################################################
# Attacks and spell casting
####################################################################################################
func cast_spell() -> void:
	is_casting = true	
	cast_fire_1.play()
	play_animation(last_direction, "cast")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_casting:
		is_casting = false

####################################################################################################
# Hitbox
####################################################################################################
