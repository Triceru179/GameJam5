extends Node

var player = null

func _ready():
	yield(get_tree(), "idle_frame")
	
	player = get_tree().get_current_scene().get_node("World/Player")

func get_player_direction_to(point: Vector2):
	if player != null:
		return (point - player.global_position).normalized()
	else:
		return Vector2.ZERO

func get_player_sqr_distance_to(point: Vector2):
	if player != null:
		return (point - player.global_position).length_squared()
	else:
		return 0
