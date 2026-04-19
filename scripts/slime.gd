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
var waiting_for_input := false 

# --- NEW: Flag to pause walking while jumping back
var is_knocked_back := false 

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
	
	var canvas = CanvasLayer.new() 
	var label = Label.new()
	label.text = "You have killed the boss of this level.\nOther levels are coming soon...\n\nPress Enter to go to the Main Menu" 
	
	label.add_theme_font_size_override("font_size", 128) 
	label.add_theme_color_override("font_color", Color.YELLOW) 
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT) 
	
	canvas.add_child(label)
	add_child(canvas)
	
	waiting_for_input = true
	
	animated_sprite.hide() 
	if has_node("KillZone"):
		$KillZone.queue_free() 

func _process(delta: float) -> void:
	if waiting_for_input:
		if Input.is_key_pressed(KEY_ENTER):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return 

	# --- FIXED: Don't move if dead OR getting knocked back
	if is_dead or is_knocked_back:
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

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player_1": 
		if is_dead or is_knocked_back:
			return
			
		is_knocked_back = true
		
		# Reverse direction immediately so it faces away from the player
		direction *= -1
		animated_sprite.flip_h = (direction == -1)
		
		# A much smaller, quicker bump (10 pixels in 0.1 seconds)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", position.x + (direction * 10), 0.1)
		
		# Wait for the quick slide to finish
		await tween.finished
		
		# Add a tiny 0.2-second pause so it feels "stunned" before walking again
		await get_tree().create_timer(0.2).timeout
		
		is_knocked_back = false
