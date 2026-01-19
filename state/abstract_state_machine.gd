class_name AbstractStateMachine

@abstract class StateCallable:
	@abstract func update(delta: float)
	@abstract func physics_update(delta: float)
	@abstract func enter()
	@abstract func leave()
	@abstract func get_state_name() -> StringName

var state_dictionary: Dictionary[StringName, StateCallable] = {}
var current_state: StringName

func add_state_callable(abs_state_callable: StateCallable) -> void:
	state_dictionary[abs_state_callable.get_state_name()] = abs_state_callable

func set_initial_state(abs_state_callable: StateCallable) -> void:
	var state_name = abs_state_callable.get_state_name()
	if state_dictionary.has(state_name):
		_set_state(state_name)
	else:
		push_warning("no state with name " + state_name)

func update(delta: float) -> void:
	if current_state != "":
		state_dictionary[current_state].update(delta)

func physics_update(delta: float) -> void:
	if current_state != "":
		state_dictionary[current_state].physics_update(delta)

func change_state(abs_state_callable: StateCallable) -> void:
	var state_name = abs_state_callable.get_state_name()
	if state_dictionary.has(state_name):
		_set_state(state_name)
	else:
		push_warning("no state with name " + state_name)

func _set_state(state_name: StringName) -> void:
	if current_state != "":
		state_dictionary[current_state].leave()
	
	current_state = state_name
	state_dictionary[current_state].enter()
