class_name WorldDebug
extends Node3D

@export var time_label: Label
@export var customer_label: Label
@export var customer_pool_node: CustomerHold
@export var results_control: ResultsContainer

@export var first_floor_marker: Marker3D
@export var second_floor_marker: Marker3D

var tables: Array[TableCollider] = []
var customer_trigger_time := 5.
var total_customers_to_server := 20

var no_more := false

const audio_2d = preload("uid://u6mkgak3uskl")
const audio_lib := preload("res://resources/sfx/audio_lib.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	for child in get_children():
		if child is TableCollider:
			tables.append(child)
	
	call_deferred("_play_music")
	
func _play_music() -> void:
	MusicPlayer.play_title_music()
	

func _process(delta: float) -> void:
	time_label.text = "Next Customer in " + str("%0.2f" % customer_trigger_time, "s")
	customer_label.text = "Customers Left " + str(total_customers_to_server)

	if customer_pool_node.customer_pool.size() > 0 and total_customers_to_server > 0:
		if customer_trigger_time <= 0:
			var next_table: TableCollider = tables.pick_random()
			if next_table.get_table_empty():
				var table := next_table as TableCollider
				if table.global_position.y > 10:
					play_customer_enters()
					var customer_agent: CustomerAgent = customer_pool_node.move_from_customer_pool_to_active()
					total_customers_to_server -= 1
					customer_agent.global_position = second_floor_marker.global_position
					customer_agent.current_table = table
					customer_agent.exit_position = second_floor_marker.global_position
					customer_agent.set_movement_target(table.customer_seat.global_position)
				else:
					play_customer_enters()
					var customer_agent: CustomerAgent = customer_pool_node.move_from_customer_pool_to_active()
					total_customers_to_server -= 1
					customer_agent.global_position = first_floor_marker.global_position
					customer_agent.current_table = table
					customer_agent.exit_position = first_floor_marker.global_position
					customer_agent.set_movement_target(table.customer_seat.global_position)
				
				# table.currently_occupied = true
				tables.append(table)
				customer_trigger_time = 5.
			else:
				pass
		else:
			customer_trigger_time -= delta
	
	if total_customers_to_server <= 0 and customer_pool_node.active_pool_empty() and not no_more:
		no_more = true
		results_control.set_total_label(PointSystem.point_total)
		results_control.set_customers_served_label(PointSystem.customers_served)
		results_control.set_customers_left_label(PointSystem.customers_left)
		results_control.show()
		MusicPlayer.play_outro_music()


func play_customer_enters() -> void:
	var customer_enter := audio_2d.instantiate()
	add_child(customer_enter)
	customer_enter.PlayInstance(audio_lib.bell_enter)


func _on_results_reset_level() -> void:
	PointSystem.reset()
	get_tree().reload_current_scene()
