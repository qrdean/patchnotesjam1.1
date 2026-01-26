class_name ResultsContainer
extends Control

signal reset_level()

@export var total_label: Label
@export var customers_served_label: Label
@export var customers_left_label: Label

func set_total_label(text):
	total_label.text = "Total " + str(text)

func set_customers_served_label(text):
	customers_served_label.text = "Customers Served " + str(text)
	
func set_customers_left_label(text):
	customers_left_label.text = "Customers left " + str(text)
	
func _input(event) -> void:
	if event.is_action_pressed("enter") and visible:
		reset_level.emit()
