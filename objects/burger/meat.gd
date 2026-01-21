extends Area3D

enum Doneness {
	UNCOOKED,
	COOKED,
	BURNT
}

const BURNT_MAT := preload("uid://bkh3eql1cihbx")
const UNCOOKED_MAT := preload("uid://b8ksorddccfvk")
const COOKED_MAT := preload("uid://cnhacxcweucrv")

@export var done: Doneness = Doneness.UNCOOKED
@export var mesh: MeshInstance3D
@export var collision: CollisionShape3D

var held := false

func _ready() -> void:
	match done:
		Doneness.UNCOOKED:
			mesh.material_override = UNCOOKED_MAT
		Doneness.COOKED:
			mesh.material_override = COOKED_MAT
		Doneness.BURNT:
			mesh.material_override = BURNT_MAT


func drop() -> void:
	reparent(get_parent().get_parent())
	collision.disabled = false

func _on_interaction_component_player_interacted(object: Variant, player: Variant) -> void:
	if player is Player:
		self.reparent(player)
		self.position = player.item_marker_pos.position
		player.current_held_item = self
		player.interact_cast_result = null
		collision.disabled = true
		emit_signal(InteractionComponent.UNFOCUSED_SIGNAL)
