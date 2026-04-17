extends Node2D

const SPEED = 60
const HEALTH_REDUCE = 25 

signal healthChanged

@export var maxHealth: int = 200

var currentHealth: int 
var direction = 1

@onready var ray_cast_right: RayCast2D = $KillZone/RayCastRight
@onready var ray_cast_left: RayCast2D = $KillZone/RayCastLeft  
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead := false
var waiting_for_input := false # --- NEW: Flag to listen for Enter key

@onready var game_manager: Node = %GameManager

func _ready():
	currentHealth = maxHealth
	healthChanged.emit() 

func take_damage(amount: int):
	if is_dead:
		return
	
	currentHealth -= amount
	animated_sprite.play("hit") 
	healthChanged.emit()
	
	if currentHealth <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	
	game_manager.add_score()
	
	# 1. Create the Victory Screen
	var canvas = CanvasLayer.new() 
	var label = Label.new()
	# \n creates a line break. We use two to create a gap before the instructions!
	label.text = "You have killed the boss of this level.\nOther levels coming soon...\n\nPress Enter to go to the Main Menu" 
	
	label.add_theme_font_size_override("font_size", 128) 
	label.add_theme_color_override("font_color", Color.YELLOW) # Yellow looks like a Victory!
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT) 
	
	canvas.add_child(label)
	add_child(canvas)
	
	waiting_for_input = true
	
	animated_sprite.hide() # Makes the boss visually disappear
	if has_node("KillZone"):
		$KillZone.queue_free() # Deletes the KillZone so the player is perfectly safe

func _process(delta: float) -> void:
	# --- NEW: Check for Enter Key ---
	if waiting_for_input:
		if Input.is_key_pressed(KEY_ENTER):
			# Make sure this is the correct path to your main menu!
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return # Stop any other code below from running

	# If the boss is dead, don't let it move
	if is_dead:
		return

	if not is_instance_valid(ray_cast_right) or not is_instance_valid(ray_cast_left):
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "hit":
		animated_sprite.play("idle")
