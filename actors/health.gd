extends Node

signal changed(current_health)

var max_health = 1
var current_health = max_health

func do_damage(damage: int):
	current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	
	emit_signal("changed", current_health)

func maximize_health():
	current_health = max_health
