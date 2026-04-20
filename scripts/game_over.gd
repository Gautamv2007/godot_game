extends Control

var current_button_index = 0
var buttons = []
var title_label: Label
var is_animating = true

func _ready() -> void:
	buttons = [
		$CenterContainer/VBoxContainer/ButtonContainer/RestartButton,
		$CenterContainer/VBoxContainer/ButtonContainer/HomeButton
	]
	
	title_label = $CenterContainer/VBoxContainer/TitleLabel
	
	# Set initial focus
	buttons[current_button_index].grab_focus()
	
	# Display score and coins from GameStats
	if GameStats:
		$CenterContainer/VBoxContainer/ScorePanel/ScoreDisplayLabel.text = "⚔️ FINAL SCORE: " + str(GameStats.final_score)
		$CenterContainer/VBoxContainer/CoinsPanel/CoinsDisplayLabel.text = "💰 COINS: " + str(GameStats.final_coins)
	else:
		print("ERROR: GameStats autoload not found!")
	
	# Play entrance animation
	animate_entrance()

func _process(delta: float) -> void:
	# Handle up/down arrow navigation
	if Input.is_action_just_pressed("ui_up"):
		current_button_index = (current_button_index - 1) % buttons.size()
		buttons[current_button_index].grab_focus()
	
	if Input.is_action_just_pressed("ui_down"):
		current_button_index = (current_button_index + 1) % buttons.size()
		buttons[current_button_index].grab_focus()
	
	# Handle enter/space to press button
	if Input.is_action_just_pressed("ui_accept"):
		buttons[current_button_index].pressed.emit()
	
	# Pulse title animation
	if is_animating:
		pulse_title()

func animate_entrance() -> void:
	# Fade in the entire container
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	$CenterContainer/VBoxContainer.modulate.a = 0.0
	tween.tween_property($CenterContainer/VBoxContainer, "modulate:a", 1.0, 0.6)

func pulse_title() -> void:
	var pulse_speed = 2.0
	var pulse_intensity = 0.15
	var time_offset = fmod(Time.get_ticks_msec() / 1000.0, 2.0 / pulse_speed)
	var scale_factor = 1.0 + pulse_intensity * sin(time_offset * pulse_speed * PI)
	title_label.scale = Vector2(scale_factor, scale_factor)

func _on_restart_pressed() -> void:
	GameStats.reset()
	get_tree().reload_current_scene()

func _on_home_pressed() -> void:
	GameStats.reset()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
