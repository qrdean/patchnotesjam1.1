extends CenterContainer

@export var default_icon: TextureRect

@export var icon: TextureRect
@export var context: Label


func _ready() -> void:
	reset()

func reset() -> void:
	icon.texture = null
	context.text = ""

func update(text, image = default_icon, override = false) -> void:
	context.text = text
	if override:
		icon.texture = image
	else:
		icon = default_icon
