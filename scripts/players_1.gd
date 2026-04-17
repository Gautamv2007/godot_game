extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

signal healthChanged

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking := false
var is_hurt := false
var is_dead := false
var waiting_for_input := false

@export var maxHealth = 100
@onready var currentHealth:int = maxHealth

func _physics_process(delta: float) -> void:
	if waiting_for_input:
		# This looks directly at your keyboard's Enter key! No Input Map needed.
		if Input.is_key_pressed(KEY_ENTER):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return # Stop the rest of the physics code from running

	# 2. World Boundary Check (Falling into the pit)
	if global_position.y > 1000 and not is_dead:
		is_dead = true 
		waiting_for_input = true
		
		# Create the "YOU DIED" screen
		var canvas = CanvasLayer.new() 
		var label = Label.new()
		label.text = "YOU DIED\nPress Enter to return to Main Menu" 
		
		label.add_theme_font_size_override("font_size", 128) 
		label.add_theme_color_override("font_color", Color.BLACK)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.set_anchors_preset(Control.PRESET_FULL_RECT) 
		
		canvas.add_child(label)
		add_child(canvas)
		
		# Freeze the player in the air
		velocity = Vector2.ZERO 
		return
	if is_dead or is_hurt:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# If attacking -> lock control but allow physics
	if is_attacking:
		if not animated_sprite.is_playing():
			is_attacking = false
		else:
			move_and_slide()
			return

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Attack (trigger once)
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animated_sprite.play("attack")
		move_and_slide()
		return

	# Movement input
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animations (only when NOT attacking, hurt, or dead)
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")

	move_and_slide()

# --- NEW: Damage and Death Logic ---
func take_damage(amount: int):
	if is_dead or is_hurt:
		return
	
	currentHealth -= amount
	healthChanged.emit() # Tells the health bar to update
	
	if currentHealth <= 0:
		die()
	else:
		is_hurt = true
		animated_sprite.play("hit") # Make sure this matches your hit animation name!

func die():
	is_dead = true
	animated_sprite.play("death") # Make sure this matches your death animation name!

# Make sure this signal is connected via the Node panel in the editor!
func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
	elif animated_sprite.animation == "hit":
		is_hurt = false
	elif animated_sprite.animation == "death":
		# Go back to the main menu when the death animation finishes
		# Make sure "res://main_menu.tscn" exactly matches your actual file name!
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
