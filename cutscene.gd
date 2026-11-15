
extends CanvasLayer

@onready var background_overlay = $Control/BackgroundOverlay
@onready var dialogue_box = $Control/DialogueBox
@onready var dialogue_text = $Control/DialogueBox/DialogueText
@onready var screen_fade = $Control/ScreenFade

var dialogue = []


func _ready():

	background_overlay.hide()

	$Control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	background_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0

	dialogue_box.position = Vector2(40, 40)
	dialogue_box.size = Vector2(1697, 140)

	dialogue_text.modulate.a = 1.0
	dialogue_text.visible = true
	dialogue_text.add_theme_color_override("font_color", Color.WHITE)
	dialogue_text.add_theme_font_size_override("font_size", 32)

	screen_fade.show()
	screen_fade.modulate.a = 0.0


func start_cutscene(cutscenenum):

	if cutscenenum == 1:
		dialogue = [
			"Young traveller, welcome to the realm of the snow, my beloved homeland.",
			"Thank you for finding your way to a seal and freeing a part of me.",
			"Years ago, a dark force chained me and sealed me to my biome. They took away all of my powers.",
			"One of the seals has been broken. Because of this, I bestow upon you the power to control snowballs. Use this power wisely.",
			"As I am still chained I am unable to journey with you. However, journey into the dark cave where you can find the next seal.",
			"The fate of the winter biome is in your hands."
		]

	elif cutscenenum == 2:
		dialogue = [
			"I feel much more powerful, thank you for freeing me further.",
			"I gave you my blessings, take the power to have snowballs of steel.",
			"You can now break rocks with your snowballs.",
			"However, with great power comes great cost.",
			"You will not be able to throw snowballs as fast now.",
			"There is one seal left.",
			"Venture deeper into the cave and free me at last."
		]

	elif cutscenenum == 3:
		dialogue = [
			"Thank you for freeing me at last.",
			"I have been waiting for a traveller like you for a long time.",
			"As a blessing, you will earn my full power.",
			"Come meet me high up in the sky."
		]

	await fade_screen(1.0, 1.0)

	background_overlay.show()

	await fade_screen(0.0, 1.0)

	dialogue_box.show()

	for line in dialogue:
		await show_dialogue(line)

	await fade_dialogue(0.0, 0.7)
	dialogue_box.hide()

	await fade_screen(1.0, 1.0)

	background_overlay.hide()

	await fade_screen(0.0, 1.0)


func show_dialogue(message: String):

	await fade_dialogue(0.0, 0.5)

	dialogue_text.text = message
	dialogue_text.visible_characters = -1

	await fade_dialogue(1.0, 0.5)

	await get_tree().create_timer(5.0).timeout


func fade_screen(target: float, duration: float):

	var tween = create_tween()
	tween.tween_property(screen_fade, "modulate:a", target, duration)

	await tween.finished


func fade_dialogue(target: float, duration: float):

	var tween = create_tween()
	tween.tween_property(dialogue_box, "modulate:a", target, duration)

	await tween.finished


func show_text_until_input(message: String, input_action: StringName = &"ui_accept"):
	dialogue_box.show()
	dialogue_text.visible = true

	await fade_dialogue(0.0, 0.0)

	dialogue_text.text = message
	dialogue_text.visible_characters = -1

	await fade_dialogue(1.0, 0.5)

	while not Input.is_action_just_pressed(input_action):
		await get_tree().process_frame

	await fade_dialogue(0.0, 0.5)

	dialogue_box.hide()
