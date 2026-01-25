extends Node

var point_total: int = 0 
var current_multiplier: float = 1.

enum PointMultipliers {
	BurgerDelivered,
	Sliding,
	OnWall,
	InAir,
	OnPlate,
	CustomerLeave,
	Default,
}

var points_multiplier_dictionary: Dictionary[PointMultipliers, int] = {
	PointMultipliers.BurgerDelivered: 100,
	PointMultipliers.Sliding: 50,
	PointMultipliers.OnWall: 80,
	PointMultipliers.InAir: 50,
	PointMultipliers.OnPlate: 25,
	PointMultipliers.CustomerLeave: -300,
	PointMultipliers.Default: 0,
}

func calculate_points(multiplier_type: PointMultipliers) -> int:
	return points_multiplier_dictionary[multiplier_type]

func get_points() -> int:
	return point_total

func add_point(multiplier_type: PointMultipliers) -> void:
	point_total += int(current_multiplier * calculate_points(multiplier_type))
	GameManager.debug_info.set_point_label(get_point_text())

func get_point_text() -> String:
	return "Points: " + str(point_total)

func get_point_system_label(multiplier_type: PointMultipliers) -> String:
	match multiplier_type:
		PointMultipliers.BurgerDelivered:
			return "Burger Delivered"
		PointMultipliers.Sliding:
			return "Slider Delivery"
		PointMultipliers.OnWall:
			return "Off The Wall"
		PointMultipliers.InAir:
			return "From Above"
		PointMultipliers.OnPlate:
			return "Catch Me I'm Falling"
		PointMultipliers.CustomerLeave:
			return "Customer Left"
	return ""

func get_point_label(multiplier_type: PointMultipliers) -> String:
	var return_text := get_point_system_label(multiplier_type)
	var calculated_points := calculate_points(multiplier_type)
	if calculated_points > 0:
		return_text += " +"
	return_text += str(calculated_points)
	return return_text
