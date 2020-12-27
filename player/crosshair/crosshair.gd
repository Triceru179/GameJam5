extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	z_index = 1000

func _physics_process(_delta):
	position = get_global_mouse_position()

func _on_crosshair_body_entered(_body):
	get_node("Sprite").frame = 1


func _on_crosshair_body_exited(_body):
	get_node("Sprite").frame = 0
