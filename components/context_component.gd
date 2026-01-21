class_name ContextComponent 
extends CenterContainer

@export var icon: TextureRect
@export var context: Label
@export var default_icon: Texture2D = null

func _ready() -> void:
	# if !get_parent().get_parent().current_test:
	# 	self.hide()
	# 	return
	# GameManager.ui_context = self
	MessageBus.interaction_focused.connect(update)
	MessageBus.interaction_unfocused.connect(reset)
	reset()

func reset() -> void:
	icon.texture = null
	context.text = ""

func update(text, image = default_icon, override = false) -> void:
	context.text = text
	if override:
		icon.texture = image
	else:
		icon.texture = default_icon
