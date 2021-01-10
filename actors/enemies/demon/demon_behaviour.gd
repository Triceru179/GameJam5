extends Enemy

enum State {
	IDLE,
	MOVE,
	ATTACK,
	DASH,
}

const FADE_SHADOW = preload("res://actors/player/fade_shadow/FadeShadow.tscn")

var current_state: int = State.IDLE
var jump_direction := Vector2.ZERO
var dash_direction := Vector2.ZERO

onready var dash_cooldown_timer := $DashCooldown
onready var dash_duration_timer := $DashDuration

func _ready():
	._ready()
	attack_cooldown_timer.wait_time += randf() * 2
	attack_cooldown_timer.start()
	dash_cooldown_timer.wait_time -= randf()
	
	player_min_distance_to_attack = pow((6 + randi() % 4 + 1) * 16, 2)

func _physics_process(_delta):
	_flip_to_player()
	
	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			if (attack_cooldown_timer.is_stopped()
					&& player_detector.get_player_sqr_distance_to(global_position)
					< player_min_distance_to_attack):
				current_state = State.ATTACK
			
			elif (dash_cooldown_timer.is_stopped()):
				_try_dash()
			
			elif(player_detector.get_player_sqr_distance_to(global_position) >
					min_distance_to_player):
				current_state = State.MOVE
		
		State.MOVE:
			if anim_player.current_animation != Globals.ANIM_MOVE:
				anim_player.play(Globals.ANIM_MOVE)
			
			if (attack_cooldown_timer.is_stopped()
					&& player_detector.get_player_sqr_distance_to(global_position)
					< player_min_distance_to_attack):
				current_state = State.ATTACK
			
			elif (dash_cooldown_timer.is_stopped()):
				_try_dash()
			
			elif(player_detector.get_player_sqr_distance_to(global_position) <=
					min_distance_to_player):
				current_state = State.IDLE
			
			move(-player_detector.get_player_direction_to(global_position))
		
		State.ATTACK:
			if anim_player.current_animation != Globals.ANIM_ATTACK:
				anim_player.play(Globals.ANIM_ATTACK)
			
			move(jump_direction, 1.5)
		
		State.DASH:
			if anim_player.current_animation != Globals.ANIM_MOVE:
				anim_player.play(Globals.ANIM_MOVE)
			
			move(dash_direction, 2)
			
			if dash_duration_timer.is_stopped():
				current_state = State.MOVE

func start_jump(height: float, duration: float):
	_get_jump_direction()
	
	$Tween.interpolate_property($Pivot/BodyPivot/Body, "position",
		Vector2.ZERO, Vector2(0, -height), duration / 2,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property($Pivot/BodyPivot/Body, "position",
		Vector2(0, -height), Vector2.ZERO, duration / 2,
		Tween.TRANS_QUAD, Tween.EASE_IN, duration / 2)
	$Tween.start()
	
	$JumpDuration.start(duration)
	yield($JumpDuration, "timeout")
	_reset_jump_direction()

func _try_dash():
	if dash_duration_timer.is_stopped():
				
		dash_direction = -player_detector.get_player_direction_to(global_position)
		var angle = Vector2.RIGHT.angle_to(dash_direction)
		angle += deg2rad(60) if (randf() - 0.5) > 0 else -deg2rad(60)
		dash_direction = Globals.angle_to_vector(angle)
		
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(sign(body_pivot.scale.x), 0)
		
		dash_duration_timer.start()
		_spawn_dash_fade_shadow()
		$DashFadeShadowCD.start()
		
		$DashSFX.play()
		$InvincibilityTimer.start(dash_duration_timer.wait_time)
		
		dash_cooldown_timer.start()
		current_state = State.DASH

func _spawn_dash_fade_shadow():
	var shadow = FADE_SHADOW.instance()
	get_parent().add_child(shadow)
	
	var sprite = $Pivot/BodyPivot/Body
	
	shadow.setup_sprite(sprite.texture, sprite.offset, sprite.global_position,
		body_pivot.scale, sprite.hframes, sprite.vframes, sprite.frame)
	shadow.start_fade(0.5, 0.25)

func _get_jump_direction():
	jump_direction = -player_detector.get_player_direction_to(self.global_position)

func _reset_jump_direction():
	jump_direction = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Globals.ANIM_ATTACK:
			current_state = State.MOVE
			attack_cooldown_timer.start()

func _on_DashFadeShadowCD_timeout():
	_spawn_dash_fade_shadow()
	if !dash_duration_timer.is_stopped():
		$DashFadeShadowCD.start()
