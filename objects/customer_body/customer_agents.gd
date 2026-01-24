class_name CustomerAgent
extends CharacterBody3D

@export var speed := 5.0
@export var navigation_agent: NavigationAgent3D

var movement_target_position := Vector3(0, 0, 0)
var current_table: TableCollider
var exit_position: Vector3
var exiting := false

func _ready() -> void:
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	actor_setup.call_deferred()

func actor_setup() -> void:
		# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(target_position: Vector3) -> void:
	navigation_agent.set_target_position(target_position)

func _physics_process(delta: float):
	if navigation_agent.is_navigation_finished():
		if exiting:
			print_debug("exiting")
			global_position = get_parent().global_position
			set_movement_target(global_position)
			exiting = false

		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var desired_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	var new_velocity = desired_velocity - velocity
	# var desired_velocity: Vector3 = ((target_vector - parent.position).normalized() * speed)
	# return (desired_velocity - parent.velocity) 

	# velocity += current_agent_position.direction_to(next_path_position) * movement_speed * delta
	velocity += new_velocity * delta
	move_and_slide()


func _on_table_detection_area_entered(area: Area3D) -> void:
	if area is TableCollider and area == current_table:
		print_debug("at the table")
		area.customer_leave_upset.connect(_leave)
		area.customer_eaten.connect(_eaten)

func _leave(area: TableCollider) -> void:
	area.customer_leave_upset.disconnect(_leave)
	area.customer_eaten.disconnect(_eaten)
	exiting = true
	set_movement_target(exit_position)

func _eaten(area: TableCollider) -> void:
	area.customer_leave_upset.disconnect(_leave)
	area.customer_eaten.disconnect(_eaten)
	exiting = true
	set_movement_target(exit_position)
