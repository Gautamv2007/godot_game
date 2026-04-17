extends ProgressBar

@export var slime_boss: Node2D

func _ready():
	if slime_boss != null:
		slime_boss.healthChanged.connect(update_bar)
		update_bar() # Set initial health bar value

func update_bar():
	if slime_boss != null:
		# Directly set the max and current values to avoid math bugs!
		max_value = slime_boss.maxHealth
		value = slime_boss.currentHealth
