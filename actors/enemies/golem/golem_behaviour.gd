extends Enemy

enum State {
	IDLE,
	MOVE,
	ATTACK,
}

var current_state = State.IDLE

func _ready():
	._ready()
	attack_cooldown_timer.wait_time += (randf() - 0.2) * 5
	attack_cooldown_timer.start()
	player_min_distance_to_attack = pow((12 + randi() % 4 + 1) * 16, 2)

func _physics_process(_delta):
	_flip_to_player()
	
	match(current_state):
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			if (attack_cooldown_timer.is_stopped()
					&& player_detector.get_player_sqr_distance_to(global_position)
					< player_min_distance_to_attack):
				current_state = State.ATTACK
				
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
				
			elif(player_detector.get_player_sqr_distance_to(global_position) <=
					min_distance_to_player):
				current_state = State.IDLE
			
			move(-player_detector.get_player_direction_to(global_position))
		
		State.ATTACK:
			if anim_player.current_animation != Globals.ANIM_ATTACK:
				anim_player.play(Globals.ANIM_ATTACK)

func change_golem_color():
	var i = randi() % 2 + 1
	change_color(wrapi(current_color_index + i, 0, 3))

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		Globals.ANIM_ATTACK:
			current_state = State.IDLE
			attack_cooldown_timer.start()
