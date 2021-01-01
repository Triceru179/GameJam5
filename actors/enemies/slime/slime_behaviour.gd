extends "res://actors/enemies/enemy.gd"

enum State {
	IDLE,
	PREPARE,
	ATTACK,
}

const JUMP_HEIGHT = 32.0
const JUMP_DURATION = 1.0

var current_state: int = State.IDLE
var jump_direction := Vector2.ZERO

func _ready():
	setup_enemy(Globals.Colors.RED)

func _physics_process(delta):
	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			if attack_cooldown_timer.is_stopped():
				current_state = State.PREPARE
		
		State.PREPARE:
			if anim_player.current_animation != Globals.ANIM_PREPARE:
				anim_player.play(Globals.ANIM_PREPARE)
			
			if player_detector.player != null:
				jump_direction = -player_detector.get_player_direction_to(self.global_position)
		
		State.ATTACK:
			if anim_player.current_animation != Globals.ANIM_ATTACK:
				anim_player.play(Globals.ANIM_ATTACK)
				
				$Tween.interpolate_property($Pivot/BodyPivot/Body, "position",
					Vector2.ZERO, Vector2(0, -JUMP_HEIGHT), JUMP_DURATION / 2,
					Tween.TRANS_QUAD, Tween.EASE_OUT)
				$Tween.interpolate_property($Pivot/BodyPivot/Body, "position",
					Vector2(0, -JUMP_HEIGHT), Vector2.ZERO, JUMP_DURATION / 2,
					Tween.TRANS_QUAD, Tween.EASE_IN, JUMP_DURATION / 2)
				$Tween.start()
			
			var _er = move_and_slide(actor_data.max_speed * jump_direction)

func reset_jump_direction():
	jump_direction = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Globals.ANIM_PREPARE:
			current_state = State.ATTACK
		
		Globals.ANIM_ATTACK:
			current_state = State.IDLE
			attack_cooldown_timer.start()

