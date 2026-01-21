class_name PlatePickup
extends Area3D

signal plate_picked_up

@export var collision: CollisionShape3D

func _on_interaction_component_player_interacted(_object: Variant, player: Variant) -> void:
	if player is Player:
		player.automator.add_dirty_plate(1)
		hide()
		collision.disabled = true
		plate_picked_up.emit()
