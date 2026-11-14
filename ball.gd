extends CharacterBody2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

var decay := 5
var _timer := 0

func _ready():
	_update_anim()

func _physics_process(delta):
	velocity.y += 1200 * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit_object = collision.get_collider()
		if hit_object.name == "Breakable":
			pass
		else:
			# It's a wall! Bounce and decay.
			velocity = velocity.bounce(collision.get_normal())
			_lose_decay()

	_timer += delta
	if _timer >= 3:
		_timer = 0
		_lose_decay()

func _lose_decay():
	decay -= 1
	if decay <= 0:
		queue_free()
		return
	_update_anim()

func _update_anim():
	_sprite.play("Phase" + str(decay))
