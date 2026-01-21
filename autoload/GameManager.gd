extends Node

var debug_info: DebugInfo

func update_plate_count(plates: int, dirty_plates: int) -> void:
	debug_info.set_debug_label("plates: " + str(plates) + " dirty plates: " + str(dirty_plates))

func update_burger_count(burgers: int, uncooked_burgers: int) -> void:
	debug_info.set_debug_label_2("burgers: " + str(burgers) + " uncooked burgers: " + str(uncooked_burgers))
