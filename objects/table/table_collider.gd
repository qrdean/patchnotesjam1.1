class_name TableCollider
extends Area3D

signal customer_leave_upset(TableCollider)

@export var food_marker: Marker3D
@export var eating_timer := 5.0
@export var plate_pickup: PlatePickup
@export var waiting_time := 10.0

@export var debug_label: Label3D

var currently_occupied := false

var plate = null
var food = null
var eating := false

func _process(delta: float) -> void:
	debug_label.set_debug_text(currently_occupied, eating, waiting_time, eating_timer)
	if plate and food and not eating:
		eating = true

	if eating:
		eating_timer -= delta
		if eating_timer <= 0:
			if is_instance_valid(food):
				food.queue_free()
			if is_instance_valid(plate):
				plate.queue_free()
			eating = false
			eating_timer = 5.0
			waiting_time = 10.
			currently_occupied = false
			plate_pickup.collision.disabled = false
			plate_pickup.show()

	handle_waiting_time(delta)


func _on_area_entered(area: Area3D) -> void:
	if area is FoodAreaCollider:
		match area.projectile.food_type:
			FoodProjectile.FoodType.PLATE:
				if plate:
					area.projectile.queue_free()
					return
				plate = area.projectile
				set_collision_mask_value(7, false)
			FoodProjectile.FoodType.BURGER:
				if food:
					area.projectile.queue_free()
					return
				food  = area.projectile
				area.set_collision_mask_value(10, false)
				set_collision_mask_value(6, false)

		area.projectile.global_position = food_marker.global_position
		area.projectile.sleeping = true
		area.projectile.freeze = true
		area.projectile.dir = Vector3.ZERO
		area.projectile.model.basis = Basis(Vector3(0, 1, 0), 0.0)


func _on_plate_pickup_plate_picked_up() -> void:
	set_collision_mask_value(6, true)
	set_collision_mask_value(7, true)

func get_currently_occupied() -> bool:
	return currently_occupied

func set_currently_occupied(val: bool) -> void:
	currently_occupied = val

func handle_waiting_time(delta: float) -> void:
	if currently_occupied and not eating:
		if waiting_time <= 0:
			customer_leave_upset.emit(self)
			currently_occupied = false
			waiting_time = 10.
		else:
			waiting_time -= delta

func get_table_empty() -> bool:
	return not currently_occupied and not plate_pickup.visible
