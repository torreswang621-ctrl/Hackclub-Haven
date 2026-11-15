extends Control

@onready var play_button = $CenterContainer/MenuContent/PlayButton
@onready var credits_button = $CenterContainer/MenuContent/CreditsButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	credits_button.pressed.connect(_on_credits_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://opening.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://credits.tscn")
