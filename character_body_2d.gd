extends CharacterBody2D
var current_snow_cd_time = 2.5
var snowball_cd = 0
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var _animated_sprite = $AnimatedSprite2D
var _current_anim := ""
var BallScene = preload("res://ball.tscn")
var can_throw_snowballs := false

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if(direction == -1):
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.flip_h = false
	
	move_and_slide()
	if Input.is_action_just_pressed("Throw") and snowball_cd == 0 and can_throw_snowballs == true:
		throw_ball(direction)
		snowball_cd = current_snow_cd_time
	if not is_on_floor():
		_play_anim("jump")
	elif direction != 0:
		_play_anim("walk")
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
	
