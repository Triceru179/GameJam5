extends Node

enum Colors {
	DEFAULT = 7,
	RED = 0,
	BLUE = 1,
	YELLOW = 2,
	PURPLE = 3,
	WHITE = 4,
}

enum CollisionLayers {
	PlayerHitbox = 6,
	EnemyHitbox = 8,
}

const COLOR_COUNT = 3

const ACTION_UP = "action_up"
const ACTION_DOWN = "action_down"
const ACTION_RIGHT = "action_right"
const ACTION_LEFT = "action_left"
const ACTION_ATTACK_1 = "action_primary_attack"
const ACTION_COLOR_SWAP_RIGHT = "action_color_swap_right"
const ACTION_COLOR_SWAP_LEFT = "action_color_swap_left"

const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"
const ANIM_ATTACK = "attack"
const ANIM_PREPARE = "prepare"
const ANIM_SHAKE = "shake"
const ANIM_DEATH = "death"

func flip(target: Node2D, value: float, flip_vec: Vector2, weight: float):
	if value != 0 && abs(sign(flip_vec.x)) == 1:
		target.scale.x = lerp(target.scale.x, sign(value), weight)
	
	if value != 0 && abs(sign(flip_vec.y)) == 1:
		target.scale.y = lerp(target.scale.y, sign(value), weight)

func angle_to_vector(angle_rad: float) -> Vector2:
	return Vector2(cos(angle_rad), sin(angle_rad))

func blink_white(palette_swapper, duration: float = 0.1):
	var previous_index = palette_swapper.current_palette_index
	
	palette_swapper.change_palette(Globals.Colors.WHITE)
	yield(get_tree().create_timer(duration), "timeout")
	palette_swapper.change_palette(previous_index)
