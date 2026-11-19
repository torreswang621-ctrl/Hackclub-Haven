
extends Control

@onready var background = $Background
@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var screen_fade = $ScreenFade
@onready var skip_button = $SkipButton
@onready var button_1 = $Button1
@onready var button_2 = $Button2
@onready var button_3 = $Button3
@onready var button_4 = $Button4
@export var opening_image_1: Texture2D
var first_dialogue = []

func _ready():
	first_dialogue = [
		"At last I am back to my full power.",
		"For saving me, I shall grant you one wish.",
		"What will it be?"
	]
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0
	screen_fade.color = Color.BLACK
	screen_fade.show()
	skip_button.pressed.connect(_on_skip_pressed)
	button_1.pressed.connect(_on_button1_pressed)
	button_2.pressed.connect(_on_button2_pressed)
	button_3.pressed.connect(_on_button3_pressed)
	button_4.pressed.connect(_on_button4_pressed)
	skip_button.hide()
	button_1.hide()
	button_2.hide()
	button_3.hide()
	button_4.hide()
	await play_opening()

func play_opening():
	background.texture = opening_image_1
	await fade_screen(0.0, 1.5)
	dialogue_box.show()

	for line in first_dialogue:
		await show_dialogue(line)

	await fade_dialogue(0.0, 0.5)
	
	button_1.show()
	button_2.show()
	button_3.show()
	button_4.show()
func play_part_two():
	skip_button.show()
	button_1.hide()
	button_2.hide()
	button_3.hide()
	button_4.hide()
	for line in first_dialogue:
		await show_dialogue(line)
	await fade_dialogue(0.0, 0.5)
	end_scene()

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
	
func end_scene():
	await fade_screen(1.0, 1.5)
	get_tree().change_scene_to_file("res://main.tscn")

func _on_skip_pressed():
	end_scene()
func _on_button1_pressed():
	Global.phase = 10
	first_dialogue = [
		"Very well, your wish will be granted.",
		"You will have my full godly powers until the end of time.",
		"You are now the guardian of this mountain.",
		"I wish you luck."
	]
	play_part_two()

func _on_button2_pressed():
	Global.phase = 20
	first_dialogue = [
		"Very well, your wish will be granted.",
		"You shall be given speed unlike any mortal being before you.",
		"I believe you will do great things in this mountain.",
		"Farewell for now traveler. I wish you luck."
	]
	play_part_two()

func _on_button3_pressed():
	Global.phase = 30
	first_dialogue = [
		"Very well, your wish will be granted.",
		"You shall be given a jump unlike any mortal being before you.",
		"I believe you will do great things in this mountain.",
		"Farewell for now traveler. I wish you luck."
	]
	play_part_two()

func _on_button4_pressed():
	Global.phase = 40
	first_dialogue = [
		"Really, nothing at all?",
		"Very well, I shall give you my blessing.",
		"Continue to journey in the mountain traveler.",
		"I wish you luck."
	]
	play_part_two()
