extends Node

var player = null

func _ready():
	yield(get_tree(), "idle_frame")
	
	player = get_tree().get_root().get_node_or_null("World/Player")
