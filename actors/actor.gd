extends KinematicBody2D
class_name Actor

signal died

const FX_EXPLOSION = preload("res://actors/fx/Explosion.tscn")

export(Resource) var actor_data = null

var current_color_index = 0
var is_dead = false

onready var body_pivot := $Pivot/BodyPivot
onready var anim_player := $AnimationPlayer
onready var attack_spawner: AttackSpawner = $AttackSpawner

func _ready():
	var h = $Health
	h.max_health = actor_data.health
	h.maximize_health()

func attack(_rotation_offset: float = 0):
	pass

func play_sfx(audio_stream: AudioStream):
	var sfx = $SFX
	sfx.stream.audio_stream = audio_stream
	sfx.play()

func try_damaging(proj):
	if !$InvincibilityTimer.is_stopped():
		return
	
	$Health.do_damage(1)
	$InvincibilityTimer.start()

	if proj:
		proj.destroy_projectile()

func _flip(value: float):
	Globals.flip(body_pivot, value, Vector2.RIGHT, 0.7)

func _play_death_particles(offset):
	var fx = FX_EXPLOSION.instance()
	
	get_parent().add_child(fx)
	fx.global_position = global_position + offset
	fx.emitting = true

func _on_Health_changed(current_health):
	if current_health <= 0:
		pause_mode = PAUSE_MODE_STOP
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		visible = false
		is_dead = true
		emit_signal("died")
		
		_play_death_particles(Vector2.ZERO)
		queue_free()
	else:
		Globals.blink_white($BodyPaletteSwapper)
