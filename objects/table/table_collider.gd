class_name TableCollider
extends Area3D

@export var food_marker: Marker3D
@export var eating_timer := 5.0
@export var plate_pickup: PlatePickup

var current_obj
var plate = null
var food = null
var eating := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if plate and food and not eating:
		print_debug("we have both. lets eat")
		eating = true

	if eating:
		eating_timer -= delta
		if eating_timer <= 0:
			food.queue_free()
			plate.queue_free()
			eating = false
			eating_timer = 5.0
			plate_pickup.collision.disabled = false
			plate_pickup.show()
			print_debug("food eaten")


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
				set_collision_mask_value(6, false)

		area.projectile.global_position = food_marker.global_position
		area.projectile.sleeping = true
		area.projectile.freeze = true
		area.projectile.dir = Vector3.ZERO
		area.projectile.model.basis = Basis(Vector3(0, 1, 0), 0.0)


func _on_plate_pickup_plate_picked_up() -> void:
	set_collision_mask_value(6, true)
	set_collision_mask_value(7, true)
