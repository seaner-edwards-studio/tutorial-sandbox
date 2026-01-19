extends CharacterBody2D

@onready var player_animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cast_fire_1: AudioStreamPlayer2D = $CastFire1
@onready var fire_1_hitbox: Area2D = $Fire1Hitbox
@onready var collision_shape_2d: CollisionShape2D = $Fire1Hitbox/CollisionShape2D


const SPEED = 130.0
var last_direction: Vector2 = Vector2.DOWN
var is_casting: bool = false
var spellcast_hitbox_offset: Vector2

func _ready() -> void:
	# Initialize hitbox offset
	spellcast_hitbox_offset = fire_1_hitbox.position

func _physics_process(_delta: float) -> void:	
	# Disable hitbox until a spell is triggered
	# TODO: This will change when spells do the checking
	fire_1_hitbox.monitoring = false
	
	if Input.is_action_just_pressed("cast_spell") and not is_casting:
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
		update_hitbox_offset()
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
		player_animation_sprite.play(prefix + "_right")
	elif dir.x < 0:
		player_animation_sprite.play(prefix + "_left")
	elif dir.y > 0:
		player_animation_sprite.play(prefix + "_down")
	elif dir.y < 0:
		player_animation_sprite.play(prefix + "_up")

####################################################################################################
# Attacks and spell casting
####################################################################################################
func cast_spell() -> void:
	is_casting = true
	fire_1_hitbox.monitoring = true
	cast_fire_1.play()
	play_animation(last_direction, "cast")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_casting:
		is_casting = false

####################################################################################################
# Hitbox
####################################################################################################

func update_hitbox_offset() -> void:
	var x = spellcast_hitbox_offset.x
	var y = spellcast_hitbox_offset.y
	
	# TODO: Need to find a way to condtionally rotate
	# the verticals because the hitbox is a line, not
	# a square
	match last_direction:
		Vector2.LEFT:
			fire_1_hitbox.position = Vector2(-x,y)
		Vector2.RIGHT:
			fire_1_hitbox.position = Vector2(x,y)
		Vector2.UP:			
			fire_1_hitbox.position = Vector2(y,-x)
		Vector2.DOWN:
			fire_1_hitbox.position = Vector2(-y,x)


func _on_fire_1_hitbox_body_entered(body: Node2D) -> void:
		if is_casting and body.name.begins_with("green-slime"):
			print("HIT")
			print(body.name)
