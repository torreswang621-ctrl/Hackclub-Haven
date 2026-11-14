
extends CharacterBody2D

static var damaged_tiles := {}

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
			# Find which cell we hit
			var col_point = collision.get_position() - collision.get_normal() * 0.1
			var cell = hit_object.local_to_map(hit_object.to_local(col_point))

			var source_id = hit_object.get_cell_source_id(cell)
			var atlas_coords = hit_object.get_cell_atlas_coords(cell)
			var alternative_id = hit_object.get_cell_alternative_tile(cell)

			# HIT 1: Change Alternative ID 9 -> 10
			if alternative_id == 9:
				hit_object.set_cell(cell, source_id, atlas_coords, 10)

			# HIT 2: Change Alternative ID 10 -> 11
			elif alternative_id == 10:
				hit_object.set_cell(cell, source_id, atlas_coords, 11)

			# HIT 3: Destroy tile
			elif alternative_id == 11:
				hit_object.erase_cell(cell)

			_lose_decay()

			velocity = velocity.bounce(collision.get_normal())
			position += collision.get_normal() * 2

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
