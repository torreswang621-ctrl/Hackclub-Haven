
extends Area2D

var has_triggered := false

@onready var cutscene = $"../Cutscene"

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if has_triggered:
		return

	get_tree().change_scene_to_file("res://closing.tscn")
