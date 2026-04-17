extends ProgressBar

# This allows you to assign the boss node directly in the Inspector!
@export var slime_boss: Node2D
@onready var slime: Node2D = $"../.."

func _ready():
	# Make sure the boss is assigned, then connect the signal
	if slime_boss != null:
		slime_boss.healthChanged.connect(update_bar)
		update_bar() # Set initial health bar value

func update_bar():
	if slime_boss != null:
		# Calculate the percentage for the progress bar
		value = slime_boss.currentHealth * 100.0 / slime.maxHealth
