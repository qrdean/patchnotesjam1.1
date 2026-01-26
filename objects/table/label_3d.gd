extends Label3D

func set_debug_text(currently_occupied: bool, currently_eating: bool, waiting_time: float, eating_timer: float) -> void:
	if currently_occupied and not currently_eating:
		text += "Waiting Timer " + str("%0.2f" % waiting_time, "s") + "\n"
	elif currently_eating:
		text += "Eating Timer " + str("%0.2f" % eating_timer, "s")
