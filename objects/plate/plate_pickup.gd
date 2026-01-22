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


func _on_area_entered(area: Area3D) -> void:
	if area and area.get_parent() != null:
		if area.get_parent() is Player:
			area.get_parent().automator.add_dirty_plate(1)
			hide()
			collision.set_deferred("disabled", true)
			plate_picked_up.emit()
