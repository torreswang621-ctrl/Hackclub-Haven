
extends Area2D

@onready var dialogue_box = $CanvasLayer/Control/DialogueBox
@onready var dialogue_text = $CanvasLayer/Control/DialogueBox/DialogueText
@onready var screen_fade = $CanvasLayer/Control/ScreenFade

var has_triggered := false

var dialogue = [
	"Young traveller, welcome to the realm of the snow, my beloved homeland.",
	"Thank you for finding your way to a seal and freeing a part of me.",
	"Years ago, a dark force chained me and sealed me to my biome. They took away all of my powers.",
	"One of the seals has been broken. Because of this, I bestow upon you the power to control snowballs. Use this power wisely.",
	"As I am still chained I am unable to journey with you. However, journey into the dark cave where you can find the next seal.",
    "The fate of the winter biome is in your hands."
]


func _ready():
	$CanvasLayer/Control/BackgroundOverlay.hide()
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	# Make Control cover the screen
	$CanvasLayer/Control.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

# Prepare dialogue box
	dialogue_box.hide()
	dialogue_box.modulate.a = 0.0

# Give the dialogue box a position and size
	var screen_size = get_viewport_rect().size
	dialogue_box.position = Vector2(40, 40)
	dialogue_box.size = Vector2(screen_size.x - 80, 140)

# Make sure the text itself is visible
	dialogue_text.modulate.a = 1.0
	dialogue_text.visible = true
	dialogue_text.add_theme_color_override("font_color", Color.WHITE)
	dialogue_text.add_theme_font_size_override("font_size", 32)
	# Prepare screen fade
	screen_fade.show()
	screen_fade.modulate.a = 0.0


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if has_triggered:
		return
	body.velocity.x = 100
	while not body.is_on_floor():
		await get_tree().process_frame
	has_triggered = true
	body.set_physics_process(false)
	body.get_node("AnimatedSprite2D").play("idle")
	await fade_screen(1.0, 1.0)
	$CanvasLayer/Control/BackgroundOverlay.show()
	await fade_screen(0.0, 1.0)
	dialogue_box.show()
	for line in dialogue:
		await show_dialogue(line)
	await fade_dialogue(0.0, 0.7)
	dialogue_box.hide()
	await fade_screen(1.0, 1.0)
	$CanvasLayer/Control/BackgroundOverlay.hide()
	await fade_screen(0.0, 1.0)
	body.set_physics_process(true)
	body.can_throw_snowballs = true


func show_dialogue(message: String):
	# Fade old paragraph out
	await fade_dialogue(0.0, 0.5)

	# Change the text
	dialogue_text.text = message
	dialogue_text.visible_characters = -1

	# Fade new paragraph in
	await fade_dialogue(1.0, 0.5)

	# Keep paragraph on screen for 5 seconds
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
