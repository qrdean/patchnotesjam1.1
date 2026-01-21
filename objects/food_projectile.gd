class_name FoodProjectile
extends RigidBody3D

enum FoodType {
	PLATE,
	DIRTY_PLATE,
	BURGER
}

@export var food_type: FoodType
@export var rotation_speed = 1.0
@export var model: Node3D

var dir := Vector3.ZERO
var dead := false

func _process(delta: float):
	if dir != Vector3.ZERO:
		model.rotate(dir, rotation_speed*delta)
		
	if linear_velocity == Vector3.ZERO and not dead:
		dir = Vector3.ZERO
		dead = true
		
	if dead:
		await get_tree().create_timer(0.5).timeout
		queue_free()
