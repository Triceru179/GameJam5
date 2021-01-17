extends Node
class_name AttackSpawner

const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn")

func execute_attack(attack_data: AttackData, direction: Vector2, position: Vector2,
		is_enemy_projectile: bool, color_index: int):
	var proj_node = get_tree().get_current_scene().get_node_or_null("World/Projectiles")
	
	if proj_node == null:
		var n = YSort.new()
		n.name = "Projectiles"
		get_tree().get_current_scene().get_node("World").add_child(n)
		proj_node = n
	
	var rotation_step = 0
	var proj_initial_rot = direction.normalized().angle()
		
	rotation_step = deg2rad(attack_data.spread / attack_data.number_of_projectiles)
	proj_initial_rot += (0 if attack_data.number_of_projectiles % 2 != 0
			else rotation_step / 2)
	
	for i in range(-attack_data.number_of_projectiles / 2,
			attack_data.number_of_projectiles / 2 + attack_data.number_of_projectiles % 2):
		var proj = PROJECTILE_SCENE.instance()
		var angle = proj_initial_rot + rotation_step * i
		var rot_vec = Globals.angle_to_vector(angle)
		
		proj_node.add_child(proj)
		
		proj.position = position
		proj.rotation = angle
		proj.setup_projectile(attack_data.projectile_data,
			rot_vec, is_enemy_projectile, color_index)
