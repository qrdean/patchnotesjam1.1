class_name MainMenu
extends Control

const WORLD_DEBUG := preload("uid://bf4ivh4fctgc2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_outro_music()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		var next_level = WORLD_DEBUG.instantiate()
		get_tree().root.add_child(next_level)
		get_tree().current_scene = next_level
		queue_free()
