extends Node

var final_score: int = 0
var final_coins: int = 0

func set_final_stats(score: int, coins: int) -> void:
	final_score = score
	final_coins = coins

func reset() -> void:
	final_score = 0
	final_coins = 0
