
extends Control

@onready var back_button = $BackButton
@onready var buttons = [
	$PlayButton,
	$PlayButton2,
	$PlayButton3,
	$PlayButton4
]

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	for i in range(buttons.size()):
		var phase = i + 1
		var button = buttons[i]

		# Disable phases that haven't been unlocked
		button.disabled = phase > Global.maxphase

		# Connect each button to its own phase
		button.pressed.connect(start_game.bind(phase))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func start_game(phase: int):
	if phase > Global.maxphase:
		return

	Global.phase = phase
	get_tree().change_scene_to_file("res://Game.tscn")
