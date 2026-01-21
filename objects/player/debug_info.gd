class_name DebugInfo
extends Control

@export var debug_label: Label
@export var debug_label_2: Label

func _ready() -> void:
	GameManager.debug_info = self

func set_debug_label(text: String) -> void:
	debug_label.text = text

func set_debug_label_2(text: String) -> void:
	debug_label_2.text = text
