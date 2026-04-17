extends ProgressBar

@onready var player_1: CharacterBody2D = $"../../Player_1"

func _ready():
	# Connect the signal from player_1 so it updates automatically
	player_1.healthChanged.connect(update)
	update()

func update():
	value = player_1.currentHealth * 100 / player_1.maxHealth
