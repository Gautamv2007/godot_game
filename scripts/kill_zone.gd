extends Area2D

# Damage the boss deals to the player
@export var damage_amount: int = 25 

# NEW: Damage the player deals to the boss per hit
@export var player_damage_to_boss: int = 20 

func _on_body_entered(body: Node2D) -> void:
	# If player is attacking → Boss takes damage instead of dying instantly
	if body.has_method("is_attacking") or "is_attacking" in body:
		if body.is_attacking:
			if get_parent().has_method("take_damage"):
				get_parent().take_damage(player_damage_to_boss)
			return

	# Otherwise → Player takes damage
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
