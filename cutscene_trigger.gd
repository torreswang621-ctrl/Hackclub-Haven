
extends Area2D

@onready var dialogue_box = $CanvasLayer/Control/DialogueBox
@onready var dialogue_text = $CanvasLayer/Control/DialogueBox/DialogueText
@onready var screen_fade = $CanvasLayer/Control/ScreenFade

var has_triggered := false

var dialogue = [
	"Young traveller, welcome to the realm of the snow, my beloved homeland.",
	"Thank you for finding your way to my treasure and freeing me.",
	"Years ago, a dark force chained me and sealed me to my biome. They took away all of my powers.",
	"One of the seals has been broken. Because of this, I bestow upon you the power to control snowballs. Use this power wisely.",
	"As I am still chained I am unable to journey with you. However, journey into the dark cave where you can find the next seal.",
    "The fate of the winter biome is in your hands."
]


func _ready():
	print("CUTSCENE TRIGGER READY!")

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0

	screen_fade.modulate.a = 0.0


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if has_triggered:
		return

	print("PLAYER ENTERED CUTSCENE!")

	body.velocity.x = 100

	# Wait until the player reaches the floor
	while not body.is_on_floor():
		await get_tree().process_frame

	print("PLAYER LANDED!")

	has_triggered = true

	# Stop player movement
	body.set_physics_process(false)

	# Fade screen to black
	await fade_screen(1.0, 1.0)

	# Fade screen back in
	await fade_screen(0.0, 1.0)

	# Show dialogue box
	dialogue_box.show()

	# Display each paragraph
	for line in dialogue:
		await show_dialogue(line)

	# Fade out final paragraph
	await fade_dialogue(0.0, 0.7)

	dialogue_box.hide()

	# Allow player movement again
	body.set_physics_process(true)

	# Give player snowball powers
	body.can_throw_snowballs = true

	print("CUTSCENE FINISHED!")


func show_dialogue(message: String):
	# Fade old paragraph out
	await fade_dialogue(0.0, 0.5)

	# Change text
	dialogue_text.text = message

	# Make text visible
	dialogue_text.visible_characters = -1

	# Fade new paragraph in
	await fade_dialogue(1.0, 0.5)

	# Keep paragraph on screen
	await get_tree().create_timer(5.0).timeout


func fade_screen(target: float, duration: float):
	var tween = create_tween()

	tween.tween_property(
		screen_fade,
		"modulate:a",
		target,
		duration
	)

	await tween.finished


func fade_dialogue(target: float, duration: float):
	var tween = create_tween()

	tween.tween_property(
		dialogue_box,
		"modulate:a",
		target,
		duration
	)

	await tween.finished
