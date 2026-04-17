extends Node2D

const SPEED = 60
const HEALTH_REDUCE = 25 

signal healthChanged

@export var maxHealth: int = 200

# Removed @onready so it doesn't wait for child nodes
var currentHealth: int 

var direction = 1

@onready var ray_cast_right: RayCast2D = $KillZone/RayCastRight
@onready var ray_cast_left: RayCast2D = $KillZone/RayCastLeft  
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead := false

@onready var game_manager: Node = %GameManager

# --- NEW: Initialize health properly ---
func _ready():
	currentHealth = maxHealth
	# Tell the health bar to update now that the boss is fully loaded
	healthChanged.emit() 

func take_damage(amount: int):
	if is_dead:
		return
	
	currentHealth -= amount
	
	# Play the hit animation! 
	# (Make sure "hit" is the exact name in your SpriteFrames)
	animated_sprite.play("hit") 
	
	healthChanged.emit() # Tell the health bar to update
	
	# If health drops to 0, trigger the death logic
	if currentHealth <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	
	set_process(false)
	set_physics_process(false)
	game_manager.add_score()
	queue_free()

func _process(delta: float) -> void:
	if not is_instance_valid(ray_cast_right) or not is_instance_valid(ray_cast_left):
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
	
# Make sure this signal is connected via the Node panel in the editor!
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "hit":
		# Change "default" to whatever your boss's normal walking animation is named!
		# It might be "walk", "idle", or "run" depending on how you named it.
		animated_sprite.play("idle")
