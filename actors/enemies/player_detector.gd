extends Node

var player = null

func _ready():
	yield(get_tree(), "idle_frame")
	
	player = get_tree().get_root().get_node_or_null("Main/World/Player")

func get_player_direction_to(position: Vector2):
	if player != null:
		return (position - player.global_position).normalized()
	else:
		return Vector2.ZERO
