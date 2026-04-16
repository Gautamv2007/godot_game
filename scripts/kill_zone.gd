#extends Area2D
#
#@export var damage_amount_slime: int = 10 # You can change this in the inspector
#@export var damage_amount_slime_boss: int = 25
#func _on_body_entered(body: Node2D) -> void:
	## If player is attacking → destroy slime instead
	#if body.has_method("is_attacking") or "is_attacking" in body:
		#if body.is_attacking:
			#get_parent().die()
			#return
#
	## Otherwise → Player takes damage
	#if body.has_method("take_damage"):
		#body.take_damage(damage_amount_slime)
		
extends Area2D

# We only need ONE variable. Because it has @export, we can 
# change this number in the Inspector for different enemies!

@export var damage_amount: int = 10

func _on_body_entered(body: Node2D) -> void:
	# If player is attacking → destroy enemy instead
	if body.has_method("is_attacking") or "is_attacking" in body:
		if body.is_attacking:
			get_parent().die()
			return

	# Otherwise → Player takes damage
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
