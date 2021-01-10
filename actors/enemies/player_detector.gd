extends Node

var player = null

func _ready():
	yield(get_tree(), "idle_frame")
	
	player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("tree_exiting", self, "_on_Player_tree_exiting")

func get_player_direction_to(point: Vector2):
	if player != null:
		return (point - player.global_position).normalized()
	else:
		return Vector2(randf() - 0.5, randf() - 0.5).normalized()

func get_player_sqr_distance_to(point: Vector2):
	if player != null:
		return (point - player.global_position).length_squared()
	else:
		return 128000

func _on_Player_tree_exiting():
	player = null
