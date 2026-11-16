
extends Control

@onready var background = $Background
@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var screen_fade = $ScreenFade
@onready var skip_button = $SkipButton

@export var opening_image_1: Texture2D

var first_dialogue = [
	"At last I am back to my full power.",
	"For saving me, I shall grant you one wish.",
	"What will it be?"
]

func _ready():
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0
	screen_fade.color = Color.BLACK
	screen_fade.show()
	skip_button.pressed.connect(_on_skip_pressed)
	await play_opening()

func play_opening():
	background.texture = opening_image_1
	await fade_screen(0.0, 1.5)
	dialogue_box.show()

	for line in first_dialogue:
		await show_dialogue(line)

	await fade_dialogue(0.0, 0.5)
	await fade_screen(1.0, 1.5)

	Global.phase = 0
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func show_dialogue(message: String):
	await fade_dialogue(0.0, 0.5)
	dialogue_text.text = message
	dialogue_text.visible_characters = -1
	await fade_dialogue(1.0, 0.5)
	await get_tree().create_timer(3.0).timeout

func fade_screen(target: float, duration: float):
	var tween = create_tween()
	tween.tween_property(screen_fade, "color:a", target, duration)
	await tween.finished

func fade_dialogue(target: float, duration: float):
	var tween = create_tween()
	tween.tween_property(dialogue_box, "modulate:a", target, duration)
	await tween.finished
	
func _on_skip_pressed():
	Global.phase = 0
	get_tree().change_scene_to_file("res://mainmenu.tscn")
