extends Control

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	# Change "res://Game.tscn" to the actual path of your game scene file
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_pressed() -> void:
	# This tells Godot to completely close the game
	get_tree().quit()
