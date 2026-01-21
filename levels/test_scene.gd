extends Node3D

@export var test_projectile: bool
var food_projectile = preload("res://objects/food_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_action"):
		if test_projectile:
			var new_food_proj = food_projectile.instantiate()
			new_food_proj.linear_velocity = -global_transform.basis.z * 10.
			add_child(new_food_proj)
