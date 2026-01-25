class_name CustomerHold 
extends Node3D

var customer_pool: Array[CustomerAgent] = []
var active_pool: Dictionary[int, CustomerAgent] = {}

func _ready() -> void:
	for child in get_children():
		if child is CustomerAgent:
			customer_pool.append(child)

func move_from_customer_pool_to_active() -> CustomerAgent:
	var customer: CustomerAgent = customer_pool.pop_back()
	active_pool[customer.get_instance_id()] = customer
	return customer

func move_from_active_to_pool(instance_id: int) -> void:
	var customer: CustomerAgent = active_pool[instance_id]
	customer_pool.append(customer)
	active_pool.erase(instance_id)
