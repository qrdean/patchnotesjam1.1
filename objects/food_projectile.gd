class_name FoodProjectile
extends RigidBody3D

enum FoodType {
	PLATE,
	BURGER
}

@export var food_type: FoodType
@export var rotation_speed = 1.0
@export var model: Node3D

@export var arc_time := 0.2
@export var clean_up_time := 60.

var dir := Vector3.ZERO
var dead := false
var impulsed_applied := false
var point_system_at_time_of_throw := PointSystem.PointMultipliers.Default
var is_on_plate := false

func _ready() -> void:
	pass

func _process(delta: float):
	clean_up_time -= delta
	if clean_up_time <= 0:
		queue_free()
		return

	if arc_time >= 0.:
		arc_time -= delta

	if dir != Vector3.ZERO:
		model.rotate(dir, rotation_speed*delta)
		
	if linear_velocity == Vector3.ZERO and not dead:
		dir = Vector3.ZERO
		dead = true
		
	if dead:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _physics_process(_delta: float) -> void:
	if FoodType.BURGER == food_type:
		if not impulsed_applied:
			apply_impulse(Vector3.UP* 2.5)
			impulsed_applied = true
		if arc_time >= 0:
			pass
			# apply_force(Vector3.UP / 1.5)
			# apply_impulse(Vector3.UP / 1.5)
			# add_constant_force(Vector3.UP * 3.) 
		else:
			pass
			# constant_force = Vector3.ZERO


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is PlatePicker:
		var plate = area.get_parent()
		#reparent(plate, true)
		#linear_velocity = Vector3.ZERO
		global_position = plate.global_position
		linear_velocity = plate.linear_velocity
		is_on_plate = true
