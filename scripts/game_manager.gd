extends Node

var score = 0
@onready var label: Label = $"../CanvasLayer/Label"

func add_point():
	score += 1
	label.text = "Coins: " + str(score)

var score_by_kill = 0
@onready var label_3: Label = $"../CanvasLayer/Label3"

func add_score():
	score_by_kill += 50
	label_3.text = "Score: " + str(score_by_kill)
	
	
