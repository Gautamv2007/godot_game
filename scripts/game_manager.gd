extends Node
@onready var label: Label = %Label

var coin_counter = 0

func add_point():
	coin_counter += 1
	label.text = "Coins: " + str(coin_counter)

var score_by_kill = 0
@onready var label_3: Label = $"../CanvasLayer/Label3"

func add_score():
	score_by_kill += 50
	label_3.text = "Score: " + str(score_by_kill)
	
	
