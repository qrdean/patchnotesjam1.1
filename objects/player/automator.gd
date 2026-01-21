class_name Automator
extends Node

@export var burger_timer := 5.0
@export var max_burgers := 6
@export var plate_timer := 5.0
@export var max_plates := 12

var current_plates := 6 
var current_dirty_plates := 0
var current_burgers := 0
var current_uncooked_burgers := 6

var simulation_time := 1.0

func _process(delta: float) -> void:
	GameManager.update_plate_count(current_plates, current_dirty_plates)
	GameManager.update_burger_count(current_burgers, current_uncooked_burgers)
	clean_plate(delta)
	make_burger(delta)
	# _simulation_dirty(delta)


func clean_plate(delta: float) -> void:
	if current_dirty_plates > 0:
		plate_timer -= delta
		if plate_timer <= 0:
			current_dirty_plates -= 1
			current_plates += 1
			plate_timer = 5.

func add_dirty_plate(plates: int) -> void:
	if all_plates() < max_plates:
		current_dirty_plates += plates

func all_plates() -> int:
	return current_dirty_plates + current_plates

func _simulation_dirty(delta) -> void:
	simulation_time -= delta
	if simulation_time <= 0.:
		add_dirty_plate(1)
		simulation_time = 1.0

func make_burger(delta: float) -> void:
	if current_burgers <= max_burgers and current_uncooked_burgers > 0:
		if burger_timer <= 0:
			current_uncooked_burgers -= 1
			current_burgers += 1
			burger_timer = 5.
		else:
			burger_timer -= delta
