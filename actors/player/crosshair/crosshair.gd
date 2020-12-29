extends Area2D

onready var sprite := $Sprite

var detected_actors_count := 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(_delta):
	position = get_global_mouse_position()

func _update_actors_count(value: int):
	detected_actors_count += value

func _update_crosshair_sprite():
	sprite.frame = abs(sign(detected_actors_count))

func _on_Crosshair_area_entered(_area):
	_update_actors_count(1)
	_update_crosshair_sprite()

func _on_Crosshair_area_exited(_area):
	_update_actors_count(-1)
	_update_crosshair_sprite()
