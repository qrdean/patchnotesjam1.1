class_name Player
extends CharacterBody3D

@export_range(0, 10, 0.01) var sensitivity := 3.0
@export var minPitch: float = deg_to_rad(-60)
@export var maxPitch: float = deg_to_rad(60)

@export var acceleration := 0.1
@export var deceleration := 0.25

@export var camera: Camera3D

const BASE_SPEED = 6.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * BASE_SPEED, acceleration)
		velocity.z = lerp(velocity.z, direction.z * BASE_SPEED, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()

func _input(event) -> void:
	if event.is_action_pressed("p"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# if event.is_action_just_pressed("pause"):
	# 	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# 	pause_menu.show()
	# 	get_tree().paused = true

	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion:
		handle_input_event_mouse_motion(event)

func handle_input_event_mouse_motion(event: InputEventMouseMotion) -> void:
	rotation.y -= event.screen_relative.x / 1000 * sensitivity
	camera.rotation.x -= event.screen_relative.y / 1000 * sensitivity
	camera.rotation.x = clamp(camera.rotation.x, minPitch, maxPitch)
	rotation.y = fmod(rotation.y, PI * 2)
