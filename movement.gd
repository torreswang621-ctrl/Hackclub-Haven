extends CharacterBody2D
var current_snow_cd_time = 3
var snowball_cd = 0
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var _animated_sprite = $AnimatedSprite2D
var _current_anim := ""
var BallScene = preload("res://ball.tscn")
var can_throw_snowballs := false
var throwdirection = 1;
var auto_throw_snowballs := false
var currently_throwing := false
@onready var cutscene = $"../Cutscene"
func _ready():
	Global.can_break_rock = false
	await get_tree().process_frame
	await get_tree().process_frame
	await cutscene.show_text_until_input("A and D to move", "Right")
	await cutscene.show_text_until_input("Space to jump", "Jump")
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		throwdirection = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if(direction == -1):
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.flip_h = false
	
	move_and_slide()
	if(auto_throw_snowballs):
		if(Input.is_action_just_pressed("Throw")):
			currently_throwing = !currently_throwing
		if(currently_throwing):
			if snowball_cd <= 0:
				throw_ball(throwdirection)
				snowball_cd = 5
			
	else:
		if Input.is_action_just_pressed("Throw") and snowball_cd == 0 and can_throw_snowballs == true:
			throw_ball(throwdirection)
			snowball_cd = current_snow_cd_time
	if not is_on_floor():
		if direction != 0:
			_play_anim("jump")
		else:
			_play_anim("idlejump")
	elif direction != 0:
		_play_anim("walk")
	else:
		if _current_anim == "sit" or _current_anim == "stand":
			if _current_anim == "sit" and Input.is_action_just_pressed("Taunt"):
				_play_anim("stand")
			elif Input.is_action_just_pressed("Grab"):
				_play_anim("sit")
		elif Input.is_action_just_pressed("Grab"):
			_play_anim("sit")
		else:
			_play_anim("idle")
	if !snowball_cd == 0:
		snowball_cd = snowball_cd-1
	
func _play_anim(anim_name: String) -> void:
		if _current_anim == anim_name:
			return
		_current_anim = anim_name
		_animated_sprite.play(anim_name)
		
func throw_ball(direction):
	var ball = BallScene.instantiate()
	var throw_speed := 500.0    # Horizontal speed
	var throw_height := 400.0   # Upward initial velocity (larger value = higher arc)
	if direction == -1:
		ball.global_position = global_position + Vector2(-20, -20)
	else:
		ball.global_position = global_position + Vector2(20, -20)
	get_parent().add_child(ball)
	if direction == -1:
		ball.velocity = Vector2(-throw_speed, -throw_height)
	else:
		ball.velocity = Vector2(throw_speed, -throw_height)
	
