class_name WorldDebug
extends Node3D

@export var time_label: Label
@export var customer_pool_node: CustomerHold

@export var first_floor_marker: Marker3D
@export var second_floor_marker: Marker3D

var tables: Array[TableCollider] = []
var customer_trigger_time := 5.
var total_customers_to_server := 30.

var no_more := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is TableCollider:
			tables.append(child)

func _process(delta: float) -> void:
	time_label.text = "Time Till Next Customer " + str("%0.2f" % customer_trigger_time, "s")

	if customer_pool_node.customer_pool.size() > 0 and total_customers_to_server > 0:
		if customer_trigger_time <= 0:
			if tables[0].get_table_empty():
				var table := tables.pop_front() as TableCollider
				if table.global_position.y > 10:
					var customer_agent: CustomerAgent = customer_pool_node.move_from_customer_pool_to_active()
					total_customers_to_server -= 1
					customer_agent.global_position = second_floor_marker.global_position
					customer_agent.current_table = table
					customer_agent.exit_position = second_floor_marker.global_position
					customer_agent.set_movement_target(table.global_position)
				else:
					var customer_agent: CustomerAgent = customer_pool_node.move_from_customer_pool_to_active()
					total_customers_to_server -= 1
					customer_agent.global_position = first_floor_marker.global_position
					customer_agent.current_table = table
					customer_agent.exit_position = first_floor_marker.global_position
					customer_agent.set_movement_target(table.global_position)
				
				# table.currently_occupied = true
				tables.append(table)
				no_more = true
			else:
				pass
			customer_trigger_time = 5.
		else:
			customer_trigger_time -= delta
