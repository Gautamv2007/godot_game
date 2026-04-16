extends Node

var score = 0
@onready var label: Label = $"../CanvasLayer/Label"

func add_point():
	score += 1
	label.text = "Coins: " + str(score)
	
	
