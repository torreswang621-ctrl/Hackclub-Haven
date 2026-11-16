
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

		if hit_object is TileMapLayer:
			var col_point = collision.get_position() - collision.get_normal() * 0.1
			var cell = hit_object.local_to_map(hit_object.to_local(col_point))

			var source_id = hit_object.get_cell_source_id(cell)

			if source_id == 12:
				hit_object.erase_cell(cell)
			
			elif Global.can_break_rock == true:
				if source_id == 9:
					hit_object.set_cell(cell, source_id, Vector2i(10, 0))
				elif source_id == 10:
					hit_object.erase_cell(cell)

			_lose_decay()

			velocity = velocity.bounce(collision.get_normal())
			position += collision.get_normal() * 2

		else:
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
