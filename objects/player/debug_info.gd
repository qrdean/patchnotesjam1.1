class_name DebugInfo
extends Control

@export var debug_label: Label
@export var debug_label_2: Label
@export var point_label: Label

@export var VboxContainer2: VBoxContainer
const LABEL_SETTINGS = preload("uid://cw53bn6vaddyu")

func _ready() -> void:
	GameManager.debug_info = self

func set_debug_label(text: String) -> void:
	debug_label.text = text

func set_debug_label_2(text: String) -> void:
	debug_label_2.text = text

func set_point_label(text: String) -> void:
	point_label.text = text

func add_point_label_string(text: String) -> void:
	var label := Label.new()
	label.label_settings = LABEL_SETTINGS
	label.text = text
	VboxContainer2.add_child(label)
	await get_tree().create_timer(1.5).timeout
	label.queue_free()
