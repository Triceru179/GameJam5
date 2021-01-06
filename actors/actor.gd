extends KinematicBody2D
class_name Actor

export(Resource) var actor_data = null

var current_color_index = 0

onready var body_pivot := $Pivot/BodyPivot
onready var anim_player := $AnimationPlayer
onready var attack_spawner: AttackSpawner = $AttackSpawner

func _ready():
	var h = $Health
	h.max_health = actor_data.health
	h.maximize_health()

func attack(_rotation_offset: float = 0):
	pass

func _flip(value: float):
	Globals.flip(body_pivot, value, Vector2.RIGHT, 0.7)

func _on_Hurtbox_area_entered(area):
	if !$InvincibilityTimer.is_stopped():
		return
	
	$Health.do_damage(1)
	$InvincibilityTimer.start()
	
	if area.get_parent().has_method("destroy_projectile"):
		area.get_parent().destroy_projectile()

func _on_Health_changed(current_health):
	if current_health <= 0:
		queue_free()
	else:
		Globals.blink_white($BodyPaletteSwapper)
