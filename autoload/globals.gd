extends Node

enum Colors {
	DEFAULT = 7,
	RED = 0,
	BLUE = 1,
	YELLOW = 2,
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
const ANIM_JUMP = "attack"
const ANIM_PREPARE = "prepare"
const ANIM_SHAKE = "shake"

func flip(target: Node2D, value: float, flip_vec: Vector2, weigth: float):
	if value != 0 && abs(sign(flip_vec.x)) == 1:
		target.scale.x = lerp(target.scale.x, sign(value), weigth)
	
	if value != 0 && abs(sign(flip_vec.y)) == 1:
		target.scale.y = lerp(target.scale.y, sign(value), weigth)
