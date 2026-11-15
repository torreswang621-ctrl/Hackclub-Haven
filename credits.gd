extends Control

@onready var back_button = $Center3/MenuContent/BackButton

func _ready():
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")
