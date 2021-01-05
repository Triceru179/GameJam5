extends Node2D

export(NodePath) var reference_sprite = ""

func _ready():
	var ref_sprite = get_node_or_null(reference_sprite)
	
	if ref_sprite != null:
		_update_sprite(ref_sprite)

func _process(_delta):
	var ref_sprite = get_node_or_null(reference_sprite)
	
	if ref_sprite != null:
		_update_sprite(ref_sprite)

func _update_sprite(ref_sprite: Sprite):
	var sprite = $Sprite
	
	sprite.texture = ref_sprite.texture
	sprite.hframes = ref_sprite.hframes
	sprite.vframes = ref_sprite.vframes
	sprite.frame = ref_sprite.frame

	sprite.offset = ref_sprite.offset
	sprite.scale.y = -ref_sprite.scale.y
	
	sprite.position.y = -ref_sprite.position.y
