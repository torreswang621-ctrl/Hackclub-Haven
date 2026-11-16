
extends AudioStreamPlayer

func _ready():
	var wav = stream as AudioStreamWAV
	if wav:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD

	play()
