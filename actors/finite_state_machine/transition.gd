class_name Transition

var to: State
var predicate: FuncRef
var excluded_states: Array

func configure(_to: State, _predicate: FuncRef, _excluded_states: Array = []):
	to = _to
	predicate = _predicate
	excluded_states = _excluded_states
