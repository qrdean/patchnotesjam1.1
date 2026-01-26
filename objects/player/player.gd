class_name Player
extends CharacterBody3D

@export_range(0, 10, 0.01) var sensitivity := 3.0
@export var minPitch: float = deg_to_rad(-60)
@export var maxPitch: float = deg_to_rad(60)

@export var acceleration := 0.1
@export var deceleration := .25
@export var BASE_SPEED := 9.0

@export var cross_hair_texture: TextureRect
@export var interact_cast_distance: float = 20.0

@export var camera: Camera3D
@export var food_spawn: Marker3D
@export var food_projectile_speed: float = 10.0
@export var plate_projectile_speed: float = 15.0
@export var item_marker_pos: Marker3D
@export var automator: Automator

@export var sliding_fx: AudioStreamPlayer

@export var camera_position_offset := Vector3(0, -1, 0) 
var camera_original_position: Vector3

var interact_cast_result

var current_held_item

const JUMP_VELOCITY = 5.5

var food_projectile := preload("res://objects/food_projectile.tscn")
const PLATE_PROJECTILE = preload("uid://3iqsalnwljki")
const audio_2d = preload("uid://u6mkgak3uskl")
const audio_lib := preload("res://resources/sfx/audio_lib.tres")

var sliding := false
var wall_jumping_time := 0.
var is_wall_jumping = false

func _ready() -> void:
	camera_original_position = camera.position
	GameManager.debug_info.set_point_label(PointSystem.get_point_text())

func _process(delta: float) -> void:
	if wall_jumping_time > 0.:
		wall_jumping_time -= delta
	else:
		is_wall_jumping = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		play_jump()
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("crouch") and is_on_floor() and (abs(velocity.x) > 0 || abs(velocity.z) > 0):
		play_sliding()
		sliding = true
		camera.position = lerp(camera.position, camera_original_position + camera_position_offset, 0.3)
	else:
		sliding = false
		stop_sliding()
		camera.position = lerp(camera.position, camera_original_position, 0.3)

	if Input.is_action_pressed("crouch") and not is_on_floor():
		# fall
		velocity += get_gravity() * 5.5 * delta

	interact()
	drop()
	throw_food()
	throw_plate()

	if !sliding:
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if not is_on_floor() and is_on_wall():
			handle_wall_jump(direction)

		if !is_wall_jumping:
			if direction:
				velocity.x = lerp(velocity.x, direction.x * BASE_SPEED, acceleration)
				velocity.z = lerp(velocity.z, direction.z * BASE_SPEED, acceleration)
			else:
				velocity.x = move_toward(velocity.x, 0, deceleration)
				velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()
	interact_cast()


func handle_wall_jump(direction: Vector3) -> void:
	var query := PhysicsRayQueryParameters3D.create(global_position, direction)
	query.collide_with_bodies = true
	var space_state := get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result:
		var collide_position: Vector3 = result.get("position")
		var wall_pos := position - collide_position
		if Input.is_action_just_pressed("ui_accept"):
			var new_vec := direction.normalized().reflect(wall_pos.normalized())
			new_vec = new_vec.project(Vector3.UP).normalized()
			new_vec = (new_vec + wall_pos.normalized() * 0.35).normalized()
			var vert := Vector3(-new_vec.normalized().x, 1., -new_vec.normalized().z)
			velocity = vert * velocity.length() * 1.5
			velocity.y = clampf(velocity.y, 0., 10.)
			is_wall_jumping = true
			wall_jumping_time = 0.30

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


func interact_cast() -> void:
	var space_state := camera.get_world_3d().direct_space_state
	var cross_hair_center = cross_hair_texture.position + Vector2(16, 16)
	var origin := camera.project_ray_origin(cross_hair_center)
	var end = origin + camera.project_ray_normal(cross_hair_center) * interact_cast_distance
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	var result := space_state.intersect_ray(query)
	var current_cast_result = result.get("collider")
	if !is_instance_valid(interact_cast_result):
		interact_cast_result = null
	if current_cast_result != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal(InteractionComponent.UNFOCUSED_SIGNAL):
			interact_cast_result.emit_signal(InteractionComponent.UNFOCUSED_SIGNAL)
		interact_cast_result = current_cast_result
		if interact_cast_result and interact_cast_result.has_user_signal(InteractionComponent.FOCUSED_SIGNAL):
			interact_cast_result.emit_signal(InteractionComponent.FOCUSED_SIGNAL)

func interact() -> void:
	if Input.is_action_just_pressed("interact"):
		if interact_cast_result and interact_cast_result.has_user_signal(InteractionComponent.INTERACTED_SIGNAL):
			interact_cast_result.emit_signal(InteractionComponent.INTERACTED_SIGNAL, self)

func drop() -> void:
	if Input.is_action_just_pressed("drop"):
		if current_held_item != null and current_held_item.has_method("drop"):
			current_held_item.drop()

func throw_food() -> void:
	if Input.is_action_just_pressed("throw"):
		var new_food_proj = food_projectile.instantiate()
		get_tree().root.add_child(new_food_proj)
		new_food_proj.global_position = food_spawn.global_position
		new_food_proj.dir = Vector3(0, -1, 0)
		new_food_proj.linear_velocity = -food_spawn.global_transform.basis.z * food_projectile_speed
		new_food_proj.point_system_at_time_of_throw = get_player_state_to_points()
		play_throw_fx()

func throw_plate() -> void:
	if Input.is_action_just_pressed("throw_plate"):
		var new_food_proj = PLATE_PROJECTILE.instantiate()
		get_tree().root.add_child(new_food_proj)
		new_food_proj.global_position = food_spawn.global_position
		new_food_proj.dir = Vector3(0, -1, 0)
		new_food_proj.linear_velocity = -food_spawn.global_transform.basis.z * plate_projectile_speed


func get_player_state_to_points() -> PointSystem.PointMultipliers:
	if sliding:
		return PointSystem.PointMultipliers.Sliding 
	if is_wall_jumping or is_on_wall():
		return PointSystem.PointMultipliers.OnWall
	if not is_on_floor():
		return PointSystem.PointMultipliers.InAir
	return PointSystem.PointMultipliers.Default

func play_jump() -> void:
	var jump_fx = audio_2d.instantiate()
	add_child(jump_fx)
	jump_fx.PlayInstance(audio_lib.player_jump, 0.42)

func play_sliding() -> void:
	if not sliding_fx.playing:
		sliding_fx.play()

func stop_sliding() -> void:
	if sliding_fx.playing:
		sliding_fx.stop()

func play_throw_fx() -> void:
	var throw_fx := audio_2d.instantiate()
	add_child(throw_fx)
	throw_fx.PlayInstance(audio_lib.throw_fx)
