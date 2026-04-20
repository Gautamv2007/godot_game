extends Node
@onready var coins_label: Label = %CoinsLabel
@onready var score_label: Label = %ScoreLabel

var coin_counter = 0

func add_point():
	coin_counter += 1
	coins_label.text = "💰 COINS: " + str(coin_counter)

var score_by_kill = 0

func add_score():
	score_by_kill += 50
	score_label.text = "⚔️ SCORE: " + str(score_by_kill)
	
	
