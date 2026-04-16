extends Node2D

const SPEED = 60

const HEALTH_REDUCE = 25

var direction = 1

@onready var ray_cast_left: RayCast2D = $KillZone_Boss/RayCastLeft
@onready var ray_cast_right: RayCast2D = $KillZone_Boss/RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
var is_dead := false

@onready var game_manager: Node = %GameManager


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
		
	position.x += direction *  SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
