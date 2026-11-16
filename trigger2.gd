
extends Area2D


@onready var cutscene = $"../Cutscene"

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if Global.phase > 2:
		return

	body.velocity.x = -100

	while not body.is_on_floor():
		await get_tree().process_frame

	body.set_physics_process(false)
	body.get_node("AnimatedSprite2D").play("idle")

	await cutscene.start_cutscene(2)

	body.set_physics_process(true)
	Global.can_break_rock = true
	body.current_snow_cd_time = 15
