extends Node
class_name StateMachine

signal current_state_changed(state)

const EMPTY_TRANSITIONS: Array = []

export(NodePath) var _starting_state

# If false, you will need to call "process_state"
# in a node's processment function
export(bool) var _internal_processing = true

var _current_state: State
var previous_state: State

var _transitions: Dictionary

var _current_transitions: Array
var _any_transitions: Array

func _ready():
	yield(get_parent(), "ready")
	_initialize()

func _process(_delta: float) -> void:
	_process_transitions()

func _physics_process(delta: float) -> void:
	if _internal_processing:
		process_state(delta)

func process_state(delta: float) -> void:
	if (!_current_state):
		return

	_current_state.update(delta)

func set_state(state: State) -> void:
	if (!state):
		return
	
	if (_current_state):
		_current_state.exit()

	previous_state = _current_state

	_current_state = state
	_change_current_transitions(_current_state)
	_current_state.enter()
	
	emit_signal("current_state_changed", _current_state)

func add_transition(from: State, to: State, predicate: FuncRef) -> void:
	if (!_transitions.has(from)):
		_transitions[from] = []
	
	var t = Transition.new()
	t.configure(to, predicate)
	_transitions[from].append(t)
	
func add_any_transition(to: State, predicate: FuncRef, excluded_states: Array = []) -> void:
	var t = Transition.new()
	t.configure(to, predicate, excluded_states)
	_any_transitions.append(t)

func _initialize() -> void:
	var state: State = get_node(_starting_state) as State
	if (!state):
		push_error("Couldn't initialize state machine. Missing starting state.")
		get_tree().quit()
	
	set_state(state)

func _process_transitions() -> void:
	var t = _get_transition()
	if (t != null):
		set_state(t)

func _get_transition() -> State:
	for t in _any_transitions:
		t = t as Transition
		if (t && t.to != _current_state && !t.excluded_states.has(_current_state)
			&& t.predicate.is_valid() && t.predicate.call_func()):
			return t.to

	for t in _current_transitions:
		t = t as Transition
		if (t && t.predicate.is_valid() && t.predicate.call_func()):
			return t.to

	return null

func _change_current_transitions(state: State) -> void:
	if (_transitions.has(state)):
		_current_transitions = _transitions[state]
		return
	
	_current_transitions = EMPTY_TRANSITIONS
