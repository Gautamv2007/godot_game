extends Area2D

@export var damage_amount: int = 25

func _on_body_entered(body: Node2D) -> void:
	# Add this line to see if the boss even detects the touch!
	print("The boss just touched: ", body.name) 
	
	if body.has_method("is_attacking") or "is_attacking" in body:
		if body.is_attacking:
			get_parent().die()
			return

	if body.has_method("take_damage"):
		print("The body HAS the take_damage method! Applying damage...")
		body.take_damage(damage_amount)
	else:
		print("The body DOES NOT have the take_damage method.")
