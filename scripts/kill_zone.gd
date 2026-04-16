extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	# If player is attacking → destroy slime instead
	if body.has_method("is_attacking") or "is_attacking" in body:
		if body.is_attacking:
			get_parent().die()
			return

	# Otherwise → player dies
	print("You died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
