class_name Audio2d
extends Node3D

@export var audio: AudioStreamPlayer

func PlayInstance(audio_struct: AudioStruct, seek: float = 0.) -> void:
	audio.stream = audio_struct.audio as AudioStream
	audio.volume_db = audio_struct.volume_db
	audio.pitch_scale = audio_struct.pitch
	audio.play()
	audio.seek(seek)

func _process(_delta: float) -> void:
	if !audio.is_playing():
		queue_free()
