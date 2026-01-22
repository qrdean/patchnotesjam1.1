class_name WorldDebug
extends Node3D

@export var time_label: Label

var tables: Array[TableCollider] = []
var customer_trigger_time := 5.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is TableCollider:
			child.customer_leave_upset.connect(_triggerme)
			tables.append(child)

func _process(delta: float) -> void:
	time_label.text = "Time Till Next Customer " + str("%0.2f" % customer_trigger_time, "s")

	if customer_trigger_time <= 0:
		if tables[0].get_table_empty():
			var table := tables.pop_front() as TableCollider
			table.currently_occupied = true
			tables.append(table)
		else:
			pass
		customer_trigger_time = 5.
	else:
		customer_trigger_time -= delta

func _triggerme(table: TableCollider) -> void:
	print_debug("triggering " + str(table))
