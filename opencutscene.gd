
extends Control

@onready var background = $Background
@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var screen_fade = $ScreenFade

@export var opening_image_1: Texture2D
@export var opening_image_2: Texture2D

var first_dialogue = [
	"A young traveler left his town to adventure the world.",
	"He was eager to see the vast world."
]

var second_dialogue = [
	"He journeyed day and night, until he reached a snowy mountain.",
	"He ran in, eager to explore.",
	"He couldn't wait for the adventure that lay ahead."
]

func _ready():
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0
	screen_fade.color = Color.BLACK
	screen_fade.show()
	await play_opening()

func play_opening():
	background.texture = opening_image_1
	await fade_screen(0.0, 1.5)
	dialogue_box.show()

	for line in first_dialogue:
		await show_dialogue(line)

	await fade_dialogue(0.0, 0.5)
	await fade_screen(1.0, 1.5)

	background.texture = opening_image_2
	await fade_screen(0.0, 1.5)

	for line in second_dialogue:
		await show_dialogue(line)

	await fade_dialogue(0.0, 0.7)
	dialogue_box.hide()
	await fade_screen(1.0, 1.5)

	get_tree().change_scene_to_file("res://main.tscn")

func show_dialogue(message: String):
	await fade_dialogue(0.0, 0.5)
	dialogue_text.text = message
	dialogue_text.visible_characters = -1
	await fade_dialogue(1.0, 0.5)
	await get_tree().create_timer(5.0).timeout

func fade_screen(target: float, duration: float):
	var tween = create_tween()
	tween.tween_property(screen_fade, "color:a", target, duration)
	await tween.finished

func fade_dialogue(target: float, duration: float):
	var tween = create_tween()
	tween.tween_property(dialogue_box, "modulate:a", target, duration)
	await tween.finished
