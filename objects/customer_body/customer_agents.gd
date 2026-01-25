class_name CustomerAgent
extends CharacterBody3D

@export var speed := 5.0
@export var navigation_agent: NavigationAgent3D
@export var table_detection: Area3D
@export var animation_player: AnimationPlayer

const IDLE_ANIMATION = "idle" 
const WALK_ANIMATION = "walk" 
const EAT_ANIMATION = "eating" 

var customer_hold: CustomerHold

var movement_target_position := Vector3(0, 0, 0)
var current_table: TableCollider
var exit_position: Vector3
var exiting := false
var anim_state := ANIM_STATE.IDLE

enum ANIM_STATE {
	EATING,
	WALKING,
	IDLE
}

func _ready() -> void:
	if get_parent() is CustomerHold:
		customer_hold = get_parent()
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

func _process(_delta: float) -> void:
	print_debug(anim_state)
	match anim_state:
		ANIM_STATE.EATING:
			if animation_player.current_animation != EAT_ANIMATION:
				animation_player.play(EAT_ANIMATION)
		ANIM_STATE.WALKING:
			if animation_player.current_animation != WALK_ANIMATION:
				animation_player.play(WALK_ANIMATION)
		ANIM_STATE.IDLE:
			if animation_player.current_animation != IDLE_ANIMATION:
				animation_player.play(IDLE_ANIMATION)

func _physics_process(delta: float):
	if navigation_agent.is_navigation_finished():
		if anim_state != ANIM_STATE.EATING:
			anim_state = ANIM_STATE.IDLE
		if exiting and customer_hold != null:
			table_detection.set_collision_mask_value(5, true)
			global_position = customer_hold.global_position
			customer_hold.move_from_active_to_pool(get_instance_id())
			set_movement_target(global_position)
			exiting = false
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var desired_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	var new_velocity = desired_velocity - velocity
	velocity += new_velocity * delta
	move_and_slide()


func _on_table_detection_area_entered(area: Area3D) -> void:
	if area is TableCollider and area == current_table:
		print_debug("at the table")
		table_detection.set_collision_mask_value(5, false)
		area.customer_leave_upset.connect(_leave)
		area.customer_eaten.connect(_eaten)
		area.customer_eating.connect(_eating)

func _leave(area: TableCollider) -> void:
	anim_state = ANIM_STATE.WALKING
	area.customer_leave_upset.disconnect(_leave)
	area.customer_eaten.disconnect(_eaten)
	area.customer_eating.disconnect(_eating)
	exiting = true
	set_movement_target(exit_position)

func _eaten(area: TableCollider) -> void:
	anim_state = ANIM_STATE.WALKING
	area.customer_leave_upset.disconnect(_leave)
	area.customer_eaten.disconnect(_eaten)
	area.customer_eating.disconnect(_eating)
	exiting = true
	set_movement_target(exit_position)

func _eating() -> void:
	anim_state = ANIM_STATE.EATING
