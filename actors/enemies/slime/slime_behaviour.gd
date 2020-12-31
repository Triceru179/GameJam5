extends "res://actors/enemies/enemy.gd"

enum State {
	IDLE,
	ATTACK,
	STAGGER,
}

var current_state: int = State.IDLE
