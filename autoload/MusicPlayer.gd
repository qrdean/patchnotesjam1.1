extends Node

enum {
	OPEN,
	OPEN_LOOP,
	BREAKDOWN,
	OUTRO
}
const MUSIC = preload("uid://w5p8sk5y7pul")

var music_lib: MusicLib = preload("uid://w5p8sk5y7pul")
var current_music: AudioStreamPlayer
var current_music_title

func play_title_music() -> void:
	play_next_track(music_lib.full_main_loop)
	current_music_title = OPEN

func play_outro_music() -> void:
	play_next_track(music_lib.outro_loop)
	current_music_title = OUTRO

func play_next_track(sound_track: MusicStruct) -> void:
	var last_track = current_music
	var track: AudioStreamPlayer = GlobalAudioPlayer.play_sound(sound_track.audio, false)
	track.volume_db = sound_track.volume_db
	track.bus = "Music"
	if is_instance_valid(last_track):
		last_track.stop()
		last_track.queue_free()
	track.finished.connect(_track_finishes)
	track.play()
	current_music = track


func _track_finishes() -> void:
	print_debug("track finished")
