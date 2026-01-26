extends Node

enum {
	OPEN,
	BREAKDOWN,
	OUTRO
}

var music_lib: MusicLib = preload("uid://w5p8sk5y7pul")
var current_music: AudioStreamPlayer

func play_title_music() -> void:
	pass
	
func play_next_track(sound_track: MusicStruct) -> void:
	var last_track = current_music
	var track: AudioStreamPlayer = GlobalAudioPlayer.play_sound(sound_track.audio, false)
	track.volume_db = sound_track.volume_db
	track.bus = "Music"
	if is_instance_valid(last_track):
		last_track.stop()
		last_track.queue_free()
	
	track.play()
	current_music = track

