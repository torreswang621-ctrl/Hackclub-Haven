extends AudioStreamPlayer

func _ready():
	print("BACKGROUND MUSIC LOADED!")
	if stream:
		play()
	else:
		print("ERROR: NO MUSIC ASSIGNED!")
