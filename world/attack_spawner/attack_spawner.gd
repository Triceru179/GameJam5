extends Node

const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn")

func execute_attack(pattern: AttackPatternData, direction: Vector2, position: Vector2, collision_layer: int):
	var dir: Vector2 = direction.normalized()
	var proj_node = get_tree().get_root().get_node("Main/World/Projectiles")
	if proj_node == null:
		var n = Node.new()
		n.name = "Projectiles"
		get_tree().get_root().get_node("Main/World").add_child(n)
		proj_node = n
	
	for attack_data in pattern.attack_datas:
		var rotation_step = 0
		var proj_initial_rot = 0
		
		if attack_data.spread == 360:
			rotation_step = attack_data.spread / attack_data.projectiles.size()
			proj_initial_rot = dir.angle()
		else:
			rotation_step = attack_data.spread / (attack_data.projectiles.size() - 1)
			proj_initial_rot = dir.angle() - deg2rad(attack_data.spread / 2)
		
		for i in range(attack_data.projectiles.size()):
			var proj = PROJECTILE_SCENE.instance()
			var angle = proj_initial_rot + deg2rad(rotation_step * i)
			var rot_vec = Vector2(cos(angle), sin(angle))
			
			proj_node.add_child(proj)
			
			proj.position = position
			proj.setup_projectile(attack_data.projectiles[i],
				rot_vec, collision_layer)
		
		dir = dir.rotated(deg2rad(pattern.rotation_per_attack))
		yield(get_tree().create_timer(pattern.inbetween_delay), "timeout")
