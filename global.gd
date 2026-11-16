extends Node
var phase = 0
var maxphase = 0
var can_break_rock = false
func _process(_delta):
	maxphase = max(maxphase, phase)
