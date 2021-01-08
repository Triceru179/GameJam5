extends Node

export(float) var time_to_destroy = 1

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time_to_destroy
	timer.connect("timeout", self, "queue_free")
	
	timer.start()
	
