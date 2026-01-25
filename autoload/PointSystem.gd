extends Node

var point_total 

enum PointMultipliers {
	BurgerDelivered,
	Sliding,
	OnWall,
	InAir,
	OnPlate,
}

var points_multiplier_dictionary: Dictionary[PointMultipliers, int] = {
	PointMultipliers.BurgerDelivered: 100,
	PointMultipliers.Sliding: 150,
	PointMultipliers.OnWall: 180,
	PointMultipliers.InAir: 150,
	PointMultipliers.OnPlate: 125,
}

func calculate_points(multiplier_type: PointMultipliers) -> int:
	return points_multiplier_dictionary[multiplier_type]
