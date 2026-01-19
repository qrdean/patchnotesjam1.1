class_name InteractionComponent
extends Node

signal player_interacted(object, player)

@export var context: String = ""
@export var override_icon: bool = false
@export var new_icon: Texture2D = null

var disabled := false
var mesh
var parent
# var highlight_material = preload("res://assets/Materials/interactable_highlight.tres")
# var fxLib: AudioLib = preload("res://resources/audio_lib.tres")
# var audioInstance2D = preload("res://resources/Audio2d.tscn")

# var interact_fx: Audio2d = null
@export var highlight_material: Material
var interact_fx

const FOCUSED_SIGNAL = "focused"
const UNFOCUSED_SIGNAL = "unfocused"
const INTERACTED_SIGNAL = "interacted"

func _ready() -> void:
	parent = get_parent()
	connect_parent()
	set_default_mesh()
	setup_children()

func in_range() -> void:
	if disabled:
		return
	if mesh:
		mesh.material_overlay = highlight_material
	MessageBus.interaction_focused.emit(context, new_icon, override_icon)

func not_in_range() -> void:
	if mesh:
		mesh.material_overlay = null
	MessageBus.interaction_unfocused.emit()

func on_interact(interacter: Player) -> void:
	if disabled:
		return
	if !interact_fx or !is_instance_valid(interact_fx):
		play_interaction_fx()
	player_interacted.emit(parent, interacter)

func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")

	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "not_in_range"))
	parent.connect("interacted", Callable(self, "on_interact"))

func set_default_mesh() -> void:
	if mesh:
		pass
	else:
		for i in parent.get_children():
			if i is CSGMesh3D or i is MeshInstance3D:
				mesh = i

func setup_children() -> void:
	for i in get_children():
		if i.has_signal("picked_up_item"):
			i.connect("picked_up_item", Callable(self, "remove_object"))

func remove_object(_resource: Resource) -> void:
	not_in_range()
	parent.remove_user_signal("focused")
	parent.remove_user_signal("unfocused")
	parent.remove_user_signal("interacted")
	parent.queue_free()

func remove_interaction(_resource: Resource) -> void:
	not_in_range()
	parent.remove_user_signal("focused")
	parent.remove_user_signal("unfocused")
	parent.remove_user_signal("interacted")
	
func play_interaction_fx() -> void:
	pass
	# interact_fx = audioInstance2D.instantiate()
	# get_tree().root.add_child(interact_fx)
	# interact_fx.PlayInstance(fxLib.interaction_sound_struct)
