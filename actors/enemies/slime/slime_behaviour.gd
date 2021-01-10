extends Enemy

enum State {
	IDLE,
	MOVE,
	PREPARE,
	ATTACK,
}

var current_state: int = State.IDLE
var jump_direction := Vector2.ZERO

onready var jump_cooldown_timer := $JumpCooldown

func _ready():
	._ready()
	attack_cooldown_timer.wait_time += (randf() - 0.5) * 2
	attack_cooldown_timer.start()
	jump_cooldown_timer.wait_time += (randf() / 5)
	
	player_min_distance_to_attack = pow((12 + randi() % 4 + 1) * 16, 2)

func _physics_process(_delta):
	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			if (attack_cooldown_timer.is_stopped()
					&& player_detector.get_player_sqr_distance_to(global_position)
					< player_min_distance_to_attack):
				current_state = State.PREPARE
				
			elif jump_cooldown_timer.is_stopped():
				current_state = State.MOVE
		
		State.MOVE:
			if anim_player.current_animation != Globals.ANIM_MOVE:
				anim_player.play(Globals.ANIM_MOVE)
			
			move(jump_direction)
		
		State.PREPARE:
			if anim_player.current_animation != Globals.ANIM_PREPARE:
				anim_player.play(Globals.ANIM_PREPARE)
		
		State.ATTACK:
			if anim_player.current_animation != Globals.ANIM_ATTACK:
				anim_player.play(Globals.ANIM_ATTACK)
			
			move(jump_direction)

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

func _get_jump_direction():
	jump_direction = -player_detector.get_player_direction_to(self.global_position)

func _reset_jump_direction():
	jump_direction = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Globals.ANIM_MOVE:
			current_state = State.IDLE
			jump_cooldown_timer.start()
		
		Globals.ANIM_PREPARE:
			current_state = State.ATTACK
		
		Globals.ANIM_ATTACK:
			current_state = State.IDLE
			attack_cooldown_timer.start()

